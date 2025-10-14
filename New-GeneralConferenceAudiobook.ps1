# Requires -Version 5.0
# You may need to install HtmlAgilityPack: Install-Package HtmlAgilityPack

Add-Type -Path "C:\Path\To\HtmlAgilityPack.dll"

function Get-HtmlDocument {
    param([string]$url)
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $doc = New-Object HtmlAgilityPack.HtmlDocument
    $doc.LoadHtml($response.Content)
    return $doc
}

function Parse-Talk {
    param($sessionIndex, $talkNode, $talkNumber)
    $title = $talkNode.SelectSingleNode(".//h4")?.InnerText.Trim()
    $speaker = $talkNode.SelectSingleNode(".//h6")?.InnerText.Trim()
    $description = $talkNode.SelectSingleNode(".//div[@class='description']")?.InnerText.Trim()
    $url = $talkNode.SelectSingleNode(".//a")?.GetAttributeValue("href", "")
    return [PSCustomObject]@{
        SessionNumber = $sessionIndex
        TalkNumber = $talkNumber
        Title = $title
        Speaker = $speaker
        Description = $description
        TalkUrl = $url
    }
}

function Parse-Mp3Link {
    param([string]$html)
    $statePattern = 'window.__INITIAL_STATE__\s*=\s*"([^"]+)"'
    $stateMatch = [regex]::Match($html, $statePattern)
    if (!$stateMatch.Success) { throw "Could not get talk description page state." }
    $jsonText = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($stateMatch.Groups[1].Value))
    $mp3Pattern = '("https:[^"]*assets[^"]*mp3[^"]*")'
    $mp3Match = [regex]::Match($jsonText, $mp3Pattern)
    if (!$mp3Match.Success) { throw "Could not find talk's mp3 link." }
    $mp3Url = $mp3Match.Groups[1].Value.Trim('"')
    return $mp3Url
}

# Main logic
$mainUrl = "YOUR_MAIN_PAGE_URL"
$doc = Get-HtmlDocument -url $mainUrl
$cards = $doc.DocumentNode.SelectNodes("//nav//ul[contains(@class,'doc-map')]//ul[contains(@class,'doc-map')]//li//a")
$CARDS_MINIMUM = 5 * 6

if ($cards.Count -lt $CARDS_MINIMUM) { throw "Not enough talk cards found." }

$sessions = @()
$talks = @()
$sessionIndex = 0
$talkNumber = 0

foreach ($card in $cards) {
    $title = $card.SelectSingleNode(".//h4")?.InnerText.Trim()
    if ($title -and $title.EndsWith("Session")) {
        $sessionIndex++
        $talkNumber = 0
        $sessions += $card
        continue
    }
    $talkNumber++
    $talk = Parse-Talk -sessionIndex $sessionIndex -talkNode $card -talkNumber $talkNumber
    $talks += $talk
}

if ($talks.Count -lt $CARDS_MINIMUM) { throw "Not enough talks found." }

# Download MP3s
foreach ($talk in $talks) {
    $talkPage = Invoke-WebRequest -Uri $talk.TalkUrl -UseBasicParsing
    $mp3Url = Parse-Mp3Link -html $talkPage.Content
    $filename = "$($talk.SessionNumber)-$($talk.TalkNumber)-$($talk.Title)-$($talk.Speaker)-$([System.IO.Path]::GetFileName($mp3Url))"
    Write-Output "Invoke-WebRequest -Uri `"$mp3Url`" -UserAgent `"ChJCDev/1.0`" -OutFile `"$filename`""
}

Write-Output "✅✅ Fetched MP3s URLs for all talks!"

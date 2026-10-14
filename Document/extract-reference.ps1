$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$out = Join-Path $PSScriptRoot 'ReferenceExtract'
[IO.Directory]::CreateDirectory($out) | Out-Null
function Read-ZipText($archive, $name) {
    $entry = $archive.GetEntry($name)
    if (!$entry) { return $null }
    $reader = [IO.StreamReader]::new($entry.Open())
    try { $reader.ReadToEnd() } finally { $reader.Dispose() }
}
$source = Join-Path $PSScriptRoot '../Reference/策划案 (1).docx'
$zip = [IO.Compression.ZipFile]::OpenRead([IO.Path]::GetFullPath($source))
try {
    [xml]$doc = Read-ZipText $zip 'word/document.xml'
    $ns = [Xml.XmlNamespaceManager]::new($doc.NameTable)
    $ns.AddNamespace('w','http://schemas.openxmlformats.org/wordprocessingml/2006/main')
    $paragraphs = $doc.SelectNodes('//w:p',$ns) | ForEach-Object {
        ($_.SelectNodes('.//w:t',$ns) | ForEach-Object InnerText) -join ''
    }
    $paragraphs | Set-Content (Join-Path $out 'design-text.txt') -Encoding utf8
    foreach ($entry in $zip.Entries | Where-Object { $_.FullName -match '^word/embeddings/.+\.xlsx$' }) {
        $path = Join-Path $out ([IO.Path]::GetFileName($entry.FullName))
        [IO.Compression.ZipFileExtensions]::ExtractToFile($entry,$path,$true)
        $book = [IO.Compression.ZipFile]::OpenRead($path)
        try {
            $strings = @()
            $raw = Read-ZipText $book 'xl/sharedStrings.xml'
            if ($raw) {
                [xml]$shared = $raw
                $strings = @($shared.SelectNodes('//*[local-name()="si"]') | ForEach-Object {
                    ($_.SelectNodes('.//*[local-name()="t"]') | ForEach-Object InnerText) -join ''
                })
            }
            $lines = @()
            foreach ($sheet in $book.Entries | Where-Object { $_.FullName -match '^xl/worksheets/sheet\d+\.xml$' }) {
                $lines += "Sheet source: $($sheet.FullName)"
                [xml]$xml = Read-ZipText $book $sheet.FullName
                foreach ($row in $xml.SelectNodes('//*[local-name()="sheetData"]/*[local-name()="row"]')) {
                    $cells = foreach ($cell in $row.SelectNodes('./*[local-name()="c"]')) {
                        $v = $cell.SelectSingleNode('./*[local-name()="v"]')
                        $value = if ($v) { $v.InnerText } else { '' }
                        if ($cell.t -eq 's') { $value = $strings[[int]$value] }
                        if ($cell.t -eq 'inlineStr') { $value = ($cell.SelectNodes('.//*[local-name()="t"]') | ForEach-Object InnerText) -join '' }
                        $formula = $cell.SelectSingleNode('./*[local-name()="f"]')
                        if ($formula) { $value += " [formula=$($formula.InnerText)]" }
                        "$($cell.r)=$value"
                    }
                    $lines += $cells -join ' | '
                }
            }
            $lines | Set-Content ($path + '.txt') -Encoding utf8
        } finally { $book.Dispose() }
    }
} finally { $zip.Dispose() }
$data = [IO.File]::ReadAllBytes((Join-Path $PSScriptRoot '../Reference/cat/data.win'))
$chunks = @()
$pos = 8
while ($pos -lt $data.Length - 8) {
    $tag = [Text.Encoding]::ASCII.GetString($data,$pos,4)
    $size = [BitConverter]::ToUInt32($data,$pos+4)
    $chunks += "$tag offset=$pos bytes=$size"
    if ($tag -eq 'CODE') { $codePos = $pos + 8 }
    if ($tag -eq 'STRG') { $strPos = $pos + 8 }
    $pos += 8 + $size
}
$chunks | Set-Content (Join-Path $out 'cats-chunks.txt') -Encoding utf8
$names = for ($i=0; $i -lt [BitConverter]::ToUInt32($data,$codePos); $i++) {
    $entry = [BitConverter]::ToUInt32($data,$codePos+4+4*$i)
    $name = [BitConverter]::ToUInt32($data,$entry)
    $len = [BitConverter]::ToUInt32($data,$name-4)
    [Text.Encoding]::UTF8.GetString($data,$name,$len)
}
$names | Set-Content (Join-Path $out 'cats-code-index.txt') -Encoding utf8
$allStrings = for ($i=0; $i -lt [BitConverter]::ToUInt32($data,$strPos); $i++) {
    $entry = [BitConverter]::ToUInt32($data,$strPos+4+4*$i)
    $len = [BitConverter]::ToUInt32($data,$entry)
    [Text.Encoding]::UTF8.GetString($data,$entry+4,$len)
}
$allStrings | Set-Content (Join-Path $out 'cats-strings.txt') -Encoding utf8
Get-FileHash (Join-Path $PSScriptRoot '../Reference/cat/data.win') | Format-List | Out-String | Set-Content (Join-Path $out 'cats-source-hash.txt')
Write-Output "Extracted reference evidence to $out"

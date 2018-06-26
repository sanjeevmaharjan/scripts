# search string type https://www.indeed.com/resumes?q=teacher+this&l=
$website = "https://www.indeed.com/resumes?q=%s&l="
$host1 = "https://www.indeed.com"

echo "website: ${website}"

echo "Reading File..."
$file = Import-Csv -Delimiter "`t" -Path ".\jobs.txt"
echo "File Reading Complete..."

$file | % {
    if ($_.FindPhrase.Length -lt 3) {
        continue
    }
    echo "Querying for ${_.FindPhrase}"
    $query = $_.FindPhrase -replace " ", "+"
    $uri = $website -replace "%s", $query
    $doc = iwr -Uri $uri

    echo "Getting Files..."
    $links = $doc.Links | ? {$_.href -match "/r/.+"}

    $links | % {
        $fileUri = "${host1}/${_.href}"
        $endchar = $_.href.IndexOf("?")
        $fileName = $_.href.SubString(3, $endchar-3)
        iwr -Uri $fileUri -OutFile "${fileName}.pdf"
        echo "Saved ${fileName}.pdf"
    }
}


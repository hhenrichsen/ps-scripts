$maxSize = 1000kb
Get-ChildItem '.\resized\*.jpg' -File | ForEach-Object {Move-Item -Path $_.FullName -Destination ('old\' + $_.Name)}
Get-ChildItem *.pdf -File | ForEach-Object {magick $_.FullName ($_.BaseName + '.jpg')}
Get-ChildItem *.jpg -File | ForEach-Object {
    $newFilePath = ('resized\' + $_.BaseName + $_.Extension)
    magick convert $_.FullName -strip -define jpeg:extent=$maxSize $newFilePath
    $newFile = Get-Item $newFilePath
    if ( $newFile.Length -gt $_.Length) {
        Move-Item -Force -Path $_.FullName -Destination $newfilePath
    }
}

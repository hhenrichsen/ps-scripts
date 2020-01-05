$maxSize = 1000kb
# Move anything that we're done with into the old/ folder.
Get-ChildItem '.\resized\*.jpg' -File | ForEach-Object {Move-Item -Path $_.FullName -Destination ('old\' + $_.Name)}
# Convert pdfs to jpgs.
Get-ChildItem *.pdf -File | ForEach-Object {magick $_.FullName ($_.BaseName + '.jpg')}
# Loop through the jpgs.
Get-ChildItem *.jpg -File | ForEach-Object {
    # Create a name for the new file in the resized/ folder.
    $newFilePath = ('resized\' + $_.BaseName + $_.Extension)
    # Resize the image to around $maxSize.
    magick convert $_.FullName -strip -define jpeg:extent=$maxSize $newFilePath
    # Get a file object for the new file.
    $newFile = Get-Item $newFilePath
    # Check if the new file is bigger. If it is, use the old one.
    if ( $newFile.Length -gt $_.Length) {
        Move-Item -Force -Path $_.FullName -Destination $newfilePath
    }
}

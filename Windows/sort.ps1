ls | Where-Object { ($_.Extension -eq '.jpg') -or ($_.Extension -eq '.png') -or ($_.Extension -eq '.heic') -or ($_.Extension -eq '.mov') -or ($_.Extension -eq '.mp4') -or ($_.Extension -eq '.gif')} | ForEach-Object{

$year = $_.Name.Substring(0,4)
$mon = $_.Name.Substring(4,2)
$day = $_.Name.Substring(6,2)
$time="$year-$mon-$day"

$e = $_.Extension

if (-not (Test-Path .\$time)) {
New-Item -Path .\ -Name $time -type directory
}

mv $_ .\$time\
cd $time

if ((($e -eq ".jpg") -or ($e -eq ".png") -or ($e -eq ".heic") -or ($e -eq ".gif")) -and (-not (Test-Path .\photos))) {
New-Item -Path .\ -Name photos -type directory
}

if (($e -eq ".mov") -or ($e -eq ".mp4") -and (-not (Test-Path .\videos))) {
New-Item -Path .\ -Name videos -type directory
}

if (-not (Test-Path "$time.md")){
New-Item -Path .\ -Name "$time.md" -type file
}

mv *.jpg .\photos
mv *.png .\photos
mv *.heic .\photos
mv *.gif .\photos
mv *.mov .\videos
mv *.mp4 .\videos

if (($e -eq ".jpg") -or ($e -eq ".png") -or ($e -eq ".heic") -or ($e -eq ".gif")) {
"![$_](photos/$_)" | Out-File -Append "$time.md" }
Else {
"<video src=`"videos/$_`"></video>" | Out-File -Append "$time.md"
}

cd ..

}
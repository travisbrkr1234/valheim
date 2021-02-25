@echo off

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

set Yr=%DateTime:~0,4%
set Mon=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hr=%DateTime:~8,2%
set Min=%DateTime:~10,2%
set Sec=%DateTime:~12,2%
set timeStamp=%Yr%-%Mon%-%Day%(%Hr%-%Min%-%Sec%)
 
@echo on
xcopy /I {{worldName}}.* .\%timeStamp%

powershell Compress-Archive '.\%timeStamp%'  -Destinationpath '.\%timeStamp%'

@echo off
rmdir /s /q %timeStamp%

set fileName="%timeStamp%.zip"
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"{{messageToPost}}\"}" {{discordURL}}
gsutil cp %fileName% gs://{{bucketLocation}} && curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"{{messageToPost}}\"}" {{discordURL}}

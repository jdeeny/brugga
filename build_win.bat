zip -r Brugga.zip assets entities gamestates lib physics player ui conf.lua main.lua README.md
rename Brugga.zip Brugga.love
copy /b love.exe+Brugga.love Brugga.exe
zip Brugga_Windows.zip Brugga.exe
del Brugga.love

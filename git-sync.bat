@echo off
cd /d "%~dp0"

echo === update from repo ===
git pull origin main

echo === adding new/updated files ===
git add .

echo === commit changes ===
set /p message=Введите сообщение коммита: 
git commit -m "%message%"

echo === Send to GitHub ===
git push origin main

echo === Done ===
pause

@echo off
cd /d "%~dp0"

echo === Обновление заметок из удалённого репозитория ===
git pull origin main

echo === Добавление новых/изменённых файлов ===
git add .

echo === Коммитим изменения ===
set /p message=Введите сообщение коммита: 
git commit -m "%message%"

echo === Отправка на GitHub ===
git push origin main

echo === Готово ===
pause

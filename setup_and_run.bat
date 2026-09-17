@echo off
echo === SnapSeats Setup - Run as Administrator ===
echo.

echo [1] Stopping MySQL80 service...
net stop MySQL80
timeout /t 2 /nobreak >nul

echo.
echo [2] Starting MySQL in recovery mode (no auth)...
start /b "" "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --skip-grant-tables --skip-networking
timeout /t 5 /nobreak >nul

echo.
echo [3] Resetting root password to 'bhukya' with native auth...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -e "FLUSH PRIVILEGES; ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'bhukya'; FLUSH PRIVILEGES;"

echo.
echo [4] Stopping recovery instance...
taskkill /f /im mysqld.exe >nul 2>&1
timeout /t 3 /nobreak >nul

echo.
echo [5] Starting MySQL normally...
net start MySQL80
timeout /t 3 /nobreak >nul

echo.
echo [6] Creating snapseats_database if not exists...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pbhukya -e "CREATE DATABASE IF NOT EXISTS snapseats_database;"

echo.
echo [7] Loading database schema and seed data...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pbhukya snapseats_database < "D:\resume\BusBookingSystem-SnapSeats-main\sql_database_code_snapseats.txt"

echo.
echo === Setup complete! ===
echo.
echo [8] Starting SnapSeats server on http://localhost:3000 ...
cd /d "D:\resume\BusBookingSystem-SnapSeats-main"
node app.js

pause

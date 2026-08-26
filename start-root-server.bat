@echo off
chcp 65001 >nul
title Root - 词根拆解工具本地服务器
cd /d "%~dp0"
echo ============================================
echo  Root 词根拆解工具 - 本地服务器
echo  启动后请用浏览器访问：
echo   http://localhost:5500/root.html
echo  按 Ctrl+C 停止服务器
echo ============================================
echo.
where python >nul 2>nul
if %errorlevel% neq 0 (
  echo [错误] 未检测到 Python，请先安装 Python 并加入 PATH
  pause
  exit /b 1
)
python -m http.server 5500
pause

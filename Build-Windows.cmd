@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>&1 || (
  echo Node.js 24 est requis.
  exit /b 1
)
where cmake >nul 2>&1 || (
  echo Ouvre le terminal Developer PowerShell de Visual Studio 2022 avec C++ et CMake.
  exit /b 1
)
if not exist "client\config.generated.hpp" (
  node tools\generate-config.mjs http://127.0.0.1:8787 --local || exit /b 1
)

cmake -S . -B build -G "Visual Studio 17 2022" -A x64 || exit /b 1
cmake --build build --config Release || exit /b 1
echo Executable : build\Release\OBSYDCosmetics.exe

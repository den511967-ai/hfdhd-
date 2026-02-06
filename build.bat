@echo off
cd SilentExternal

echo Cleaning old build files...
if exist "bin\Release\net8.0-windows\win-x64" (
    rmdir /s /q "bin\Release\net8.0-windows\win-x64"
)

echo Building single-file executable...
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true

if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo Cleaning intermediate files...
for /d %%d in (bin\Release\net8.0-windows\win-x64\*) do (
    if not "%%~nxd"=="publish" (
        rmdir /s /q "%%d"
    )
)

for %%f in (bin\Release\net8.0-windows\win-x64\*) do (
    del /q "%%f"
)

echo Deleting PDB files...
del /q "bin\Release\net8.0-windows\win-x64\publish\*.pdb" 2>nul

echo.
echo   BUILD SUCCESSFUL!
echo   Output: bin\Release\net8.0-windows\win-x64\publish\SilentExternalWebView.exe
echo.
cd ..
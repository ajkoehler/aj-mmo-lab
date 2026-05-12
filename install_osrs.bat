@echo off
setlocal enabledelayedexpansion

echo ============================
echo Checking Git...
echo ============================

where git >nul 2>&1
if %errorlevel%==0 (
    echo Git already installed.
) else (
    echo Git not found. Installing...
    winget install --id Git.Git -e --source winget
)

echo ============================
echo Checking Git LFS...
echo ============================

git lfs version >nul 2>&1
if %errorlevel%==0 (
    echo Git LFS already installed.
) else (
    echo Git LFS not found. Installing...
    winget install --id GitHub.GitLFS -e --source winget
)

echo ============================
echo Checking Java JDK 11...
echo ============================

java -version 2>&1 | findstr "11." >nul
if %errorlevel%==0 (
    echo Java 11 already installed.
) else (
    echo Java 11 not found. Installing...
    winget install --id EclipseAdoptium.Temurin.11.JDK -e --source winget
)

echo ============================
echo Finding JAVA_HOME...
echo ============================

for /d %%i in ("C:\Program Files\Eclipse Adoptium\jdk-11*") do (
    set "JAVA_HOME=%%i"
)

if defined JAVA_HOME (
    setx JAVA_HOME "%JAVA_HOME%"
    echo JAVA_HOME set to:
    echo %JAVA_HOME%
) else (
    echo WARNING: Could not automatically find JAVA_HOME
)

echo ============================
echo Initializing Git LFS...
echo ============================

git lfs install

echo ============================
echo Cloning Repository...
echo ============================

if exist Singleplayer-Edition-Linux (
    echo Repository already exists. Skipping clone.
) else (
    git clone https://github.com/2009scape/Singleplayer-Edition-Linux.git
)

cd Singleplayer-Edition-Linux

echo ============================
echo Pulling LFS Files...
echo ============================

git lfs pull

echo ============================
echo Running Client...
echo ============================

if exist "%JAVA_HOME%\bin\java.exe" (
    "%JAVA_HOME%\bin\java.exe" -jar client.jar
) else (
    java -jar client.jar
)

pause
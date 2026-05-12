#!/bin/bash

set -e

echo "============================"
echo "Checking Git..."
echo "============================"

if command -v git >/dev/null 2>&1; then
    echo "Git already installed."
else
    echo "Git not found. Installing..."
    winget install --id Git.Git -e --source winget
fi

echo "============================"
echo "Checking Git LFS..."
echo "============================"

if git lfs version >/dev/null 2>&1; then
    echo "Git LFS already installed."
else
    echo "Git LFS not found. Installing..."
    winget install --id GitHub.GitLFS -e --source winget
fi

echo "============================"
echo "Checking Java JDK 11..."
echo "============================"

if java -version 2>&1 | grep '11\.' >/dev/null; then
    echo "Java 11 already installed."
else
    echo "Java 11 not found. Installing..."
    winget install --id EclipseAdoptium.Temurin.11.JDK -e --source winget
fi

echo "============================"
echo "Detecting JAVA_HOME..."
echo "============================"

JAVA_HOME=$(find "/c/Program Files/Eclipse Adoptium" -maxdepth 1 -type d -name "jdk-11*" 2>/dev/null | head -n 1)

if [ -n "$JAVA_HOME" ]; then
    export JAVA_HOME
    echo "JAVA_HOME=$JAVA_HOME"
else
    echo "WARNING: Could not detect JAVA_HOME"
fi

echo "============================"
echo "Initializing Git LFS..."
echo "============================"

git lfs install

echo "============================"
echo "Cloning Repository..."
echo "============================"

if [ -d "Singleplayer-Edition-Linux" ]; then
    echo "Repository already exists. Skipping clone."
else
    git clone https://github.com/2009scape/Singleplayer-Edition-Linux.git
fi

cd Singleplayer-Edition-Linux

echo "============================"
echo "Pulling LFS Files..."
echo "============================"

git lfs pull

echo "============================"
echo "Running Client..."
echo "============================"

if [ -n "$JAVA_HOME" ] && [ -f "$JAVA_HOME/bin/java.exe" ]; then
    "$JAVA_HOME/bin/java.exe" -jar client.jar
else
    java -jar client.jar
fi

@echo off
REM Setup script for SmartStock Core API (Windows)
REM Usage: setup.bat

echo 🚀 SmartStock Core API - Setup Script
echo ======================================

REM Check Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js v20+
    exit /b 1
)

REM Check npm
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ npm not found.
    exit /b 1
)

for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
for /f "tokens=*" %%i in ('npm -v') do set NPM_VERSION=%%i

echo ✅ Node.js %NODE_VERSION% detected
echo ✅ npm %NPM_VERSION% detected

REM Install dependencies
echo.
echo 📦 Installing dependencies...
call npm install

REM Check if .env exists
if not exist .env (
    echo.
    echo 📝 Creating .env file from .env.example...
    copy .env.example .env
    echo ⚠️  Please update .env with your configuration
)

REM Build application
echo.
echo 🔨 Building application...
call npm run build

REM Run tests
echo.
echo 🧪 Running tests...
call npm run test

REM Lint
echo.
echo ✨ Checking code quality...
call npm run lint

echo.
echo ✅ Setup complete!
echo.
echo Next steps:
echo 1. Update .env with your actual configuration
echo 2. Run 'npm run start:dev' to start development server
echo 3. Or run 'docker-compose up' for full stack
echo.
echo 📚 Read README.md for more information

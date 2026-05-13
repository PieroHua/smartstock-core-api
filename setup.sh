#!/bin/bash

# Setup script for SmartStock Core API
# Usage: ./setup.sh

set -e

echo "🚀 SmartStock Core API - Setup Script"
echo "======================================"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js v20+"
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found."
    exit 1
fi

echo "✅ Node.js $(node -v) detected"
echo "✅ npm $(npm -v) detected"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Check if .env exists
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your configuration"
fi

# Build application
echo ""
echo "🔨 Building application..."
npm run build

# Run tests
echo ""
echo "🧪 Running tests..."
npm run test

# Lint
echo ""
echo "✨ Checking code quality..."
npm run lint

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your actual configuration"
echo "2. Run 'npm run start:dev' to start development server"
echo "3. Or run 'docker-compose up' for full stack"
echo ""
echo "📚 Read README.md for more information"

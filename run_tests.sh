#!/bin/bash
set -e

echo "======================================"
echo "XYBox Flutter Test Runner"
echo "======================================"

cd /workspace

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK not found. Please install Flutter 3.x first."
    echo "   Download from: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✓ Flutter version: $(flutter --version --machine | head -1)"

# Get dependencies
echo ""
echo "Step 1: Getting dependencies..."
flutter pub get

# Run build_runner for code generation
echo ""
echo "Step 2: Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
echo ""
echo "Step 3: Running tests..."
flutter test \
    --coverage \
    --test-randomize-ordering-seed=random \
    --reporter=expanded \
    lib/test/

# Generate coverage report
echo ""
echo "Step 4: Generating coverage report..."
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    echo "✓ Coverage report generated: coverage/html/index.html"
else
    echo "⚠ lcov not installed. Install with: sudo apt-get install lcov"
fi

echo ""
echo "======================================"
echo "✓ All tests completed!"
echo "======================================"

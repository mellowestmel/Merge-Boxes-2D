
#!/bin/bash
set -e

GAME_NAME="Merge Boxes! 2D"
EXE_NAME="play.exe"

# Resolve directories
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOVE_DIR="$HOME/.cache/mb2d-build/love-11.5-win64"

# Output locations
DIST_ROOT="$HOME/mb2d-auto-built"
DIST_DIR="$DIST_ROOT/$GAME_NAME"

echo "================================"
echo " Merge Boxes! 2D Windows Build"
echo "================================"
echo

# Ask for game version
read -rp "Enter game version (e.g. 1.0.0-dev): " VERSION

if [[ -z "$VERSION" ]]; then
    echo "Error: Game version cannot be empty."
    exit 1
fi

# Prevent invalid filenames
if [[ "$VERSION" == *"/"* || "$VERSION" == *"\\"* ]]; then
    echo "Error: Invalid version name."
    exit 1
fi

RELEASE_NAME="v${VERSION}-windows"
ZIP_NAME="${RELEASE_NAME}.zip"
ZIP_PATH="$DIST_ROOT/$ZIP_NAME"

LOVE_FILE="$PROJECT_DIR/game.love"

# Validate Windows LÖVE runtime
if [[ ! -f "$LOVE_DIR/love.exe" ]]; then
    echo "Error: Cannot find Windows LÖVE runtime:"
    echo "$LOVE_DIR/love.exe"
    exit 1
fi

# Validate required project files
for FILE in main.lua conf.lua README.md CREDITS.md LICENSE; do
    if [[ ! -f "$PROJECT_DIR/$FILE" ]]; then
        echo "Error: Missing $FILE"
        exit 1
    fi
done

for DIR in src assets; do
    if [[ ! -d "$PROJECT_DIR/$DIR" ]]; then
        echo "Error: Missing directory $DIR"
        exit 1
    fi
done

# Clean previous build
echo
echo "Cleaning previous build..."

rm -rf "$DIST_DIR"
rm -f "$LOVE_FILE" "$ZIP_PATH"

mkdir -p "$DIST_DIR"

# Create .love archive
echo "Creating game archive..."

cd "$PROJECT_DIR"

zip -9 -r "$LOVE_FILE" \
    main.lua \
    conf.lua \
    src/ \
    assets/

# Fuse game archive with Windows LÖVE runtime
echo "Creating Windows executable..."

cat "$LOVE_DIR/love.exe" "$LOVE_FILE" > "$DIST_DIR/$EXE_NAME"

# Copy Windows runtime DLLs
echo "Copying Windows runtime files..."

shopt -s nullglob
DLL_FILES=("$LOVE_DIR"/*.dll)

if (( ${#DLL_FILES[@]} == 0 )); then
    echo "Error: No DLL files found in $LOVE_DIR"
    exit 1
fi

cp "${DLL_FILES[@]}" "$DIST_DIR/"
shopt -u nullglob

# Copy documentation
echo "Copying documentation..."

cp README.md CREDITS.md LICENSE "$DIST_DIR/"

# Remove temporary .love archive
rm -f "$LOVE_FILE"

# Create versioned ZIP
echo "Creating release ZIP..."

cd "$DIST_ROOT"
zip -r "$ZIP_PATH" "$GAME_NAME"

# Build summary
echo
echo "================================"
echo " Build completed successfully!"
echo "================================"
echo
echo "Version:     $VERSION"
echo "Folder:      $DIST_DIR"
echo "Archive:     $ZIP_PATH"
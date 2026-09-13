#!/bin/bash

# Folder containing the images (JPEGs, PNGs, and/or WebPs)
INPUT_FOLDER="$1"

# Desired width for resizing (height will be calculated to maintain aspect ratio)
TARGET_WIDTH="$2"

# Optional: specify quality for WebP (default is 80 if not provided)
QUALITY="${3:-80}"

# Check if width is provided
if [ -z "$TARGET_WIDTH" ]; then
    echo "Please specify a target width."
    exit 1
fi

# Loop through each image file in the input folder
for file in "$INPUT_FOLDER"/*.{webp,jpg,jpeg,png}; do
    # Check if the file exists to avoid issues if no matches are found
    if [ ! -f "$file" ]; then
        continue
    fi

    # Get the base name of the file (without extension)
    base_name=$(basename "$file" | cut -d. -f1)

    # Check the file extension
    extension="${file##*.}"

    # Resize and convert the image based on its format
    if [[ "$extension" == "jpg" || "$extension" == "jpeg" ]]; then
        # Resize JPEG and convert to WebP using ImageMagick
        magick "$file" -resize "${TARGET_WIDTH}x" -quality "$QUALITY" "$INPUT_FOLDER/${base_name}_resized.webp"
        echo "Resized and converted $file (JPEG) to ${base_name}_resized.webp with quality ${QUALITY}%."
    elif [[ "$extension" == "png" ]]; then
        # Resize PNG and convert to WebP using ImageMagick
        magick "$file" -resize "${TARGET_WIDTH}x" -quality "$QUALITY" "$INPUT_FOLDER/${base_name}_resized.webp"
        echo "Resized and converted $file (PNG) to ${base_name}_resized.webp with quality ${QUALITY}%."
    elif [[ "$extension" == "webp" ]]; then
        # Resize WebP file directly
        magick "$file" -resize "${TARGET_WIDTH}x" -quality "$QUALITY" "$INPUT_FOLDER/${base_name}_resized.webp"
        echo "Resized $file (WebP) to ${TARGET_WIDTH}px width and saved as ${base_name}_resized.webp with quality ${QUALITY}%."
    fi
done

echo "All images resized and/or converted to WebP."

#!/bin/bash

# === CONFIGURATION ===
LICENSE_TYPE="MIT"
YEAR="2025"
AUTHOR="Christos Spyridakis"
REPO_URL="https://github.com/CSpyridakis/dockerfiles"
CURRENT_DATE="31 March 2025"

# === LICENSE HEADER ===
read -r -d '' MIT_LICENSE << EOM
-----------------------------------------------------------------------------
This file has either been created using public resources or developed by the following author.

Last Modified: $CURRENT_DATE
Repository: $REPO_URL
Author: $AUTHOR

-----------------------------------------------------------------------------
License:
    If an external resource was used, proper attribution is provided afterward. In that case, 
    please disregard the licensing indicated here and ensure that the software license is
    derived from the original resource. Otherwise, use the following license.

MIT License

Copyright (c) $YEAR $AUTHOR

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-----------------------------------------------------------------------------
EOM

# === FUNCTIONS ===
add_license() {
    local file="$1"
    local comment_prefix="$2"

    # Don't add license if it already exists
    if grep -q "$LICENSE_TYPE License" "$file"; then
        echo "Already licensed: $file"
        return
    fi

    echo "Adding license to: $file"

    tmpfile=$(mktemp)
    
    # Shebang support
    if head -n 1 "$file" | grep -q "^#\!"; then
        head -n 1 "$file" > "$tmpfile"
        echo "" >> "$tmpfile"
        echo "$MIT_LICENSE" | sed "s/^/$comment_prefix /" >> "$tmpfile"
        tail -n +2 "$file" >> "$tmpfile"
    else
        echo "$MIT_LICENSE" | sed "s/^/$comment_prefix /" >> "$tmpfile"
        echo "" >> "$tmpfile"
        cat "$file" >> "$tmpfile"
    fi

    mv "$tmpfile" "$file"
}

# === FILE TYPES AND COMMENT STYLES ===
process_file() {
    local file="$1"

    case "$file" in
        *.sh | *.bash | *.py)
            add_license "$file" "#"
            ;;
        *.tf | *.tfvars)
            add_license "$file" "#"
            ;;
        *Dockerfile | *.[dD]ockerfile)
            add_license "$file" "#"
            ;;
        *.yml | *.yaml)
            add_license "$file" "#"
            ;;
        *)
            echo "Skipping: $file"
            ;;
    esac
}

# === FIND AND PROCESS FILES ===
find . -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.py" -o -name "*.tf" -o -name "*.tfvars" -o -name "Dockerfile*" -o -iname "*.dockerfile" -o -iname "*.Dockerfile" -o -name "*.yml" -o -name "*.yaml" \) 2> /dev/null | while read -r file; do
    process_file "$file"
done

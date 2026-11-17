#! /bin/bash

set -euo pipefail
cd "$(dirname "$0")/.."

version="${TAILWIND_VERSION:-v4.1.13}"

if ! ./tailwind/tailwindcss --help >/dev/null 2>&1; then
    case "$(uname -s)/$(uname -m)" in
        Linux/x86_64)  asset=tailwindcss-linux-x64 ;;
        Linux/aarch64) asset=tailwindcss-linux-arm64 ;;
        Darwin/arm64)  asset=tailwindcss-macos-arm64 ;;
        Darwin/x86_64) asset=tailwindcss-macos-x64 ;;
        *) echo "no tailwindcss build for $(uname -s)/$(uname -m)" >&2; exit 1 ;;
    esac
    echo "Fetching tailwindcss ${version} (${asset})"
    curl -fsSL -o ./tailwind/.tailwindcss.tmp \
        "https://github.com/tailwindlabs/tailwindcss/releases/download/${version}/${asset}"
    chmod +x ./tailwind/.tailwindcss.tmp
    mv ./tailwind/.tailwindcss.tmp ./tailwind/tailwindcss
fi

./tailwind/tailwindcss \
    -c ./tailwind/tailwind.config.js \
    -i ./priv/static/css/app.css \
    -o ./output/css/app.css \
    --minify

# SourShark

Site I used for organizing my projects and stuff I want to post.

## Installation

First set up [tailwind](https://tailwindcss.com/blog/standalone-cli)

```bash
mkdir -p tailwind && \
cd $_ && \
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64 && \
curl -sLO https://github.com/saadeghi/daisyui/releases/latest/download/daisyui.js && \
curl -sLO https://github.com/saadeghi/daisyui/releases/latest/download/daisyui-theme.js && \
chmod +x tailwindcss-macos-arm64 && \
mv tailwindcss-macos-arm64 tailwindcss
```

Install Elixir dependencies

```bash
mix deps.get
```

Running locally

```bash
mix run --no-halt
```

This will start up a Bandit server and a file watcher. Write the markdown files in the `priv/posts` directory and on changes the markdown will be converted into HTML and served by Bandit.

## Deployment

```bash
mix build
```

Running this will just do a conversion of all the markdown into HTML and not start a Bandit server. The resulting HTML also will not include hot reloading JavaScript.
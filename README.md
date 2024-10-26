# SourShark

Site I used for organizing my projects and stuff I want to post.

## Installation

First set up [tailwind](https://tailwindcss.com/blog/standalone-cli)

```bash
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64
chmod +x tailwindcss-macos-arm64
mv tailwindcss-macos-arm64 tailwind/tailwindcss
```

Install Elixir dependencies

```bash
mix deps.get
```

After editing files you can view them by running a build:

```bash
mix build
mix run --no-halt
```

# SourShark

Site I used for organizing my projects and stuff I want to post.

## Installation

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
./deployment/deploy_ovh.sh
```

The script builds an nginx image from `output/` and ships the `linux/amd64`
image to the OVH Podman runtime.

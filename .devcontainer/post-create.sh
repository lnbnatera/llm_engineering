#!/usr/bin/env bash
set -e

cd /workspaces/llm_engineering

echo "== Running project setup =="

sudo apt-get update
sudo apt-get -y install zstd

# Ensure uv exists
if ! command -v uv >/dev/null 2>&1; then
    echo ">> Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install ollama
if ! command -v ollama >/dev/null 2>&1; then
    echo ">> Installing ollama..."
    curl -LsSf https://ollama.com/install.sh | sudo sh
else
    echo ">> ollama already installed, skipping"
fi

# Install llama models
# ollama pull llama3.1:8b
# ollama pull gemma3:12b

# Install dependencies (only once)
if [ ! -d ".venv" ]; then
    echo ">> Installing dependencies with uv..."
    uv sync
else
    echo ">> .venv already exists, skipping"
fi

# Ensure environment is usable in terminal
echo 'export VIRTUAL_ENV=/workspaces/llm_engineering/.venv' >> ~/.bashrc
echo 'export PATH="${HOME}/.local/bin:$VIRTUAL_ENV/bin:$PATH"' >> ~/.bashrc

export VIRTUAL_ENV="/workspaces/llm_engineering/.venv"
export PATH="${HOME}/.local/bin:$VIRTUAL_ENV/bin:$PATH"

# Verify lockfile
if [ -f "uv.lock" ]; then
    echo ">> Checking lockfile consistency..."
    uv sync --frozen || uv sync
fi

echo "== Setup complete =="

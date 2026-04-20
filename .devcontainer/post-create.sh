#!/usr/bin/env bash
set -e

cd /workspaces/llm_engineering

echo "== Running project setup =="

# Ensure uv exists
if ! command -v uv >/dev/null 2>&1; then
    echo ">> Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

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

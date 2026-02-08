#!/usr/bin/env bash
set -euo pipefail

# Some pyenv/pip wheels may fail on NixOS if they can't find libstdc++.so.6.
# This patch is a pragmatic workaround for greenlet (used by some Neovim Python paths).

need() { command -v "$1" >/dev/null 2>&1 || { echo "missing: $1" >&2; exit 1; }; }
need python
need patchelf
need gcc

site="$(python -c 'import site; print(site.getsitepackages()[0])')"
so="$(find "$site" -maxdepth 2 -type f -name '_greenlet*.so' | head -n 1 || true)"
if [[ -z "${so}" ]]; then
  echo "greenlet .so not found under: $site" >&2
  exit 1
fi

libstdcpp="$(gcc -print-file-name=libstdc++.so.6)"
dir="$(dirname "$libstdcpp")"

echo "patching: $so"
echo "adding rpath: $dir"
patchelf --set-rpath "$dir" "$so"


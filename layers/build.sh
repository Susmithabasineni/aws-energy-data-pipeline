#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
rm -rf python
mkdir python
pip install -r ../requirements.txt -t python
zip -r layer.zip python
rm -rf python

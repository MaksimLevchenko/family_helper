#!/usr/bin/env bash

set -euo pipefail

if [[ "${WSL_DISTRO_NAME:-}" == "" ]]; then
  echo "This helper is intended to run inside WSL." >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  drives=("d")
else
  drives=("$@")
fi

normalize_drive() {
  local value="$1"
  value="${value%:}"
  printf '%s' "${value,,}"
}

ensure_alias() {
  local drive
  drive="$(normalize_drive "$1")"
  local mount_path="/mnt/${drive}"
  local alias_path="/${drive^^}:"

  if [[ ! -d "${mount_path}" ]]; then
    echo "Skipping ${drive^^}: ${mount_path} does not exist." >&2
    return 0
  fi

  if [[ -L "${alias_path}" ]]; then
    local current_target
    current_target="$(readlink "${alias_path}")"
    if [[ "${current_target}" == "${mount_path}" ]]; then
      echo "${alias_path} already points to ${mount_path}"
      return 0
    fi

    echo "${alias_path} points to ${current_target}, expected ${mount_path}." >&2
    echo "Update it manually or remove it first." >&2
    return 1
  fi

  if [[ -e "${alias_path}" ]]; then
    echo "${alias_path} exists and is not a symlink. Resolve it manually first." >&2
    return 1
  fi

  if [[ -w "/" ]]; then
    ln -s "${mount_path}" "${alias_path}"
  else
    sudo ln -s "${mount_path}" "${alias_path}"
  fi

  echo "Created ${alias_path} -> ${mount_path}"
}

for drive in "${drives[@]}"; do
  ensure_alias "${drive}"
done

cat <<'EOF'

WSL drive aliases are ready.
If your .dart_tool/package_config.json contains Windows URIs like:
  file:///D:/PubCache/...
Linux tools can now resolve them through:
  /D:/PubCache/...
EOF

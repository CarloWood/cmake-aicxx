#! /bin/bash

if ! git submodule --quiet foreach "$(realpath cmake/aicxx/scripts/update_submodule.sh)"' --quiet --commit $name "$path" $sha1 "$toplevel"'; then
  echo >&2 "cmake/aicxx/scripts/upsm-push.sh: fatal error."
  exit 1
fi

exec git push "$@"

#!/bin/bash
set -eu

refresh_defalut_opt_in_config() {
  local opt="--$1"
  local value="$2"
  local config_file="$KUBE_SNAP_ROOT/default-args/$3"
  local replace_line="$opt=$value"
  
  if $(grep -qE "^$opt=" $config_file); then
    sed -i "s/^$opt=.*/$replace_line/" $config_file
  else
    sed -i "$ a $replace_line" "$config_file"
  fi
}

# gcr.io to mirrorgooglecontainers
refresh_defalut_opt_in_config "pod-infra-container-image" "mirrorgooglecontainers/pause-amd64:3.1" kubelet
grep "gcr\.io" --include '*.yaml' -rl "$KUBE_SNAP_ROOT" | xargs -r sed -i 's,\([-a-zA-Z0-9_.]*gcr\.io[-a-zA-Z0-9_/.]*\)/,mirrorgooglecontainers/,g'
#!/bin/sh

### Scripts for sourcing multiple kube config files. Derived from
### https://billglover.me/2020/06/12/how-i-manage-kubernetes-config/

DEFAULT_CONTEXTS="$HOME/.kube/config"
CUSTOM_CONTEXTS="$HOME/.kube/custom-contexts"
OIFS="$IFS"
IFS=$'\n'

if test -f "${DEFAULT_CONTEXTS}"
then
  export KUBECONFIG="$DEFAULT_CONTEXTS"
else
  mkdir -p "${CUSTOM_CONTEXTS}"
  unset KUBECONFIG
  for file in `find "${CUSTOM_CONTEXTS}" -type f -name "*.yml" -or -name "*.yaml"`
  do
    export KUBECONFIG="$file:$KUBECONFIG"
  done
  IFS="$OIFS"
fi

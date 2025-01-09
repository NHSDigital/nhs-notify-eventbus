#!/bin/bash

# WARNING: Please, DO NOT edit this file! It is maintained in the Repository Template (https://github.com/nhs-england-tools/repository-template). Raise a PR instead.

set -euo pipefail

# Script to generate SBOM (Software Bill of Materials) for the repository
# content and any artefact created by the CI/CD pipeline. This is a syft command
# wrapper. It will run syft natively if it is installed, otherwise it will run
# it in a Docker container.
#
# Usage:
#   $ [options] ./create-sbom-report.sh
#
# Options:
#   BUILD_DATETIME=%Y-%m-%dT%H:%M:%S%z  # Build datetime, default is `date -u +'%Y-%m-%dT%H:%M:%S%z'`
#   FORCE_USE_DOCKER=true               # If set to true the command is run in a Docker container, default is 'false'
#   VERBOSE=true                        # Show all the executed commands, default is `false`

# ==============================================================================

function main() {

  cd "$(git rev-parse --show-toplevel)"

  create-report
  enrich-report
}

function create-report() {

  if command -v syft > /dev/null 2>&1 && ! is-arg-true "${FORCE_USE_DOCKER:-false}"; then
    run-syft-natively
  else
    run-syft-in-docker
  fi
}

function run-syft-natively() {

  syft packages dir:"$PWD" \
    --config "$PWD/scripts/config/syft.yaml" \
    --output spdx-json="$PWD/sbom-repository-report.tmp.json"
}

function run-syft-in-docker() {

  # shellcheck disable=SC1091
  source ./scripts/docker/docker.lib.sh

  # shellcheck disable=SC2155
  local image=$(name=ghcr.io/anchore/syft docker-get-image-version-and-pull)
  docker run --rm --platform linux/amd64 \
    --volume "$PWD":/workdir \
    "$image" \
      packages dir:/workdir \
      --config /workdir/scripts/config/syft.yaml \
      --output spdx-json=/workdir/sbom-repository-report.tmp.json
}

function enrich-report() {

  build_datetime=${BUILD_DATETIME:-$(date -u +'%Y-%m-%dT%H:%M:%S%z')}
  git_url=$(git config --get remote.origin.url)
  git_branch=$(git rev-parse --abbrev-ref HEAD)
  git_commit_hash=$(git rev-parse HEAD)
  git_tags=$(echo \""$(git tag | tr '\n' ',' | sed 's/,$//' | sed 's/,/","/g')"\" | sed 's/""//g')
  pipeline_run_id=${GITHUB_RUN_ID:-0}
  pipeline_run_number=${GITHUB_RUN_NUMBER:-0}
  pipeline_run_attempt=${GITHUB_RUN_ATTEMPT:-0}

  # shellcheck disable=SC2086
  jq \
    '.creationInfo |= . + {"created":"'${build_datetime}'","repository":{"url":"'${git_url}'","branch":"'${git_branch}'","tags":['${git_tags}'],"commitHash":"'${git_commit_hash}'"},"pipeline":{"id":'${pipeline_run_id}',"number":'${pipeline_run_number}',"attempt":'${pipeline_run_attempt}'}}' \
    sbom-repository-report.tmp.json \
      > sbom-repository-report.json
  rm -f sbom-repository-report.tmp.json
}

# ==============================================================================

function is-arg-true() {

  if [[ "$1" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$ ]]; then
    return 0
  else
    return 1
  fi
}

# ==============================================================================

is-arg-true "${VERBOSE:-false}" && set -x

main "$@"

exit 0

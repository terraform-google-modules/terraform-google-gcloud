#!/usr/bin/env bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -xeo pipefail

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

CLUSTER_NAME=$1
LOCATION=$2
PROJECT_ID=$3
INTERNAL=$4
USE_EXISTING_CONTEXT=$5
ENABLE_IMPERSONATE_SERVICE_ACCOUNT=$6
IMPERSONATE_SERVICE_ACCOUNT=$7

if [[ "${ENABLE_IMPERSONATE_SERVICE_ACCOUNT}" == "true" ]]; then
    if [ "$#" -lt 7 ]; then
        >&2 echo "Not all expected arguments set (expected at least 7)."
        exit 1
    fi
    shift 7
else
    shift 5
fi

if [[ "${USE_EXISTING_CONTEXT}" == "true" ]]; then

    "$@"

else

    TMPDIR=$(mktemp -d -t kubectl_wrapper_XXXXXX)
    export TMPDIR

    function cleanup {
        [[ -n "${TMPDIR}" && -d "${TMPDIR}" ]] && rm -rf "${TMPDIR}"
    }
    trap cleanup EXIT

    export KUBECONFIG="${TMPDIR}/config"

    LOCATION_TYPE=$(grep -o "-" <<< "${LOCATION}" | wc -l || true)

    CMD=(gcloud container clusters get-credentials "${CLUSTER_NAME}" --project "${PROJECT_ID}")

    if [[ "${ENABLE_IMPERSONATE_SERVICE_ACCOUNT}" == "true" && -n "${IMPERSONATE_SERVICE_ACCOUNT}" ]]; then
      CMD+=(--impersonate-service-account "${IMPERSONATE_SERVICE_ACCOUNT}")
    fi

    if [[ ${LOCATION_TYPE} -eq 2 ]]; then
        CMD+=(--zone "${LOCATION}")
    else
        CMD+=(--region "${LOCATION}")
    fi

    if [[ "${INTERNAL}" == "true" ]]; then
        CMD+=(--internal-ip)
    fi

    "${CMD[@]}"

    "$@"
fi

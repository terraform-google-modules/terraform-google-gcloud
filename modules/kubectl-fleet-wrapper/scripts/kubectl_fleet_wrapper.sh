#!/usr/bin/env bash
# Copyright 2020-2023 Google LLC
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

if [ "$#" -lt 4 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

NAME=$1
LOCATION=$2
PROJECT_ID=$3
IMPERSONATE_SERVICE_ACCOUNT=$4

shift 4

RANDOM_ID="${RANDOM}_${RANDOM}"
export TMPDIR="/tmp/kubectl_fleet_wrapper_${RANDOM_ID}"

function cleanup {
    rm -rf "${TMPDIR}"
}
trap cleanup EXIT

mkdir "${TMPDIR}"

export KUBECONFIG="${TMPDIR}/config"

CMD="gcloud container fleet memberships get-credentials ${NAME} --project ${PROJECT_ID} --location ${LOCATION}"

if [[ "${IMPERSONATE_SERVICE_ACCOUNT}" != false ]]; then
  CMD+=" --impersonate-service-account ${IMPERSONATE_SERVICE_ACCOUNT}"
fi

$CMD

"$@"

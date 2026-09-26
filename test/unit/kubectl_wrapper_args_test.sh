#!/usr/bin/env bash
# Copyright 2026 Google LLC
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

# Unit tests for the positional argument handling of the kubectl wrapper
# scripts. `gcloud` and `kubectl` are replaced with stubs, so no cluster,
# credentials or network access are required.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
KUBECTL_WRAPPER="${REPO_ROOT}/modules/kubectl-wrapper/scripts/kubectl_wrapper.sh"
FLEET_WRAPPER="${REPO_ROOT}/modules/kubectl-fleet-wrapper/scripts/kubectl_fleet_wrapper.sh"

STUB_DIR="$(mktemp -d -t kubectl_wrapper_test_XXXXXX)"
trap '[[ -n "${STUB_DIR}" && -d "${STUB_DIR}" ]] && rm -rf "${STUB_DIR}"' EXIT

cat >"${STUB_DIR}/gcloud" <<'EOF'
#!/usr/bin/env bash
echo "GCLOUD: $*"
EOF

cat >"${STUB_DIR}/kubectl" <<'EOF'
#!/usr/bin/env bash
echo "KUBECTL: $*"
EOF

chmod +x "${STUB_DIR}/gcloud" "${STUB_DIR}/kubectl"
PATH="${STUB_DIR}:${PATH}"
export PATH

FAILURES=0

# run_case <name> <expected output> <script> <args...>
function run_case {
    local name="$1"
    local expected="$2"
    local script="$3"
    shift 3

    local actual
    actual=$("${script}" "$@" 2>/dev/null | grep -E "^(GCLOUD|KUBECTL): " || true)

    if [[ "${actual}" == "${expected}" ]]; then
        echo "ok - ${name}"
    else
        echo "not ok - ${name}"
        echo "  expected:"
        echo "${expected}"
        echo "  actual:"
        echo "${actual}"
        FAILURES=$((FAILURES + 1))
    fi
}

# kubectl-wrapper: cluster_name location project_id internal use_existing_context
#                  [true impersonate_service_account] <command...>

run_case "kubectl-wrapper: zonal cluster" \
"GCLOUD: container clusters get-credentials my-cluster --project my-project --zone us-central1-a
KUBECTL: run nginx --image=nginx" \
    "${KUBECTL_WRAPPER}" my-cluster us-central1-a my-project false false \
    kubectl run nginx --image=nginx

run_case "kubectl-wrapper: regional cluster with internal ip" \
"GCLOUD: container clusters get-credentials my-cluster --project my-project --region us-central1 --internal-ip
KUBECTL: run nginx --image=nginx" \
    "${KUBECTL_WRAPPER}" my-cluster us-central1 my-project true false \
    kubectl run nginx --image=nginx

run_case "kubectl-wrapper: impersonation" \
"GCLOUD: container clusters get-credentials my-cluster --project my-project --impersonate-service-account sa@my-project.iam.gserviceaccount.com --zone us-central1-a
KUBECTL: run nginx --image=nginx" \
    "${KUBECTL_WRAPPER}" my-cluster us-central1-a my-project false false \
    true sa@my-project.iam.gserviceaccount.com \
    kubectl run nginx --image=nginx

run_case "kubectl-wrapper: existing context" \
"KUBECTL: run nginx --image=nginx" \
    "${KUBECTL_WRAPPER}" my-cluster us-central1-a my-project false true \
    kubectl run nginx --image=nginx

# Regression test: prior to the positional shift fix, this combination silently
# executed `/bin/true` instead of the supplied kubectl command and exited 0.
run_case "kubectl-wrapper: existing context with impersonation" \
"KUBECTL: run nginx --image=nginx" \
    "${KUBECTL_WRAPPER}" my-cluster us-central1-a my-project false true \
    true sa@my-project.iam.gserviceaccount.com \
    kubectl run nginx --image=nginx

# kubectl-fleet-wrapper: membership_name location project_id
#                        impersonate_service_account|false <command...>

run_case "kubectl-fleet-wrapper: no impersonation" \
"GCLOUD: container fleet memberships get-credentials my-membership --project my-project --location us-central1
KUBECTL: run nginx --image=nginx" \
    "${FLEET_WRAPPER}" my-membership us-central1 my-project false \
    kubectl run nginx --image=nginx

run_case "kubectl-fleet-wrapper: impersonation" \
"GCLOUD: container fleet memberships get-credentials my-membership --project my-project --location us-central1 --impersonate-service-account sa@my-project.iam.gserviceaccount.com
KUBECTL: run nginx --image=nginx" \
    "${FLEET_WRAPPER}" my-membership us-central1 my-project sa@my-project.iam.gserviceaccount.com \
    kubectl run nginx --image=nginx

if [[ "${FAILURES}" -ne 0 ]]; then
    >&2 echo "${FAILURES} test case(s) failed."
    exit 1
fi

echo "All test cases passed."

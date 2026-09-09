// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testutils

var (
	RetryableTransientErrors = map[string]string{
		// Error 409: Operation / Policy conflicts
		".*Error 409.*unable to queue the operation":            "Unable to queue operation.",
		".*Error 409.*There were concurrent policy changes.*":   "Concurrent policy changes.",
		".*Error 409.*Another operation is already in progress": "Another operation in progress.",
		".*Error 409.*is in use":                                "Resource in use.",

		// Rate limiting & Quotas & GCE Capacity
		".*rateLimitExceeded.*":        "Rate limit exceeded.",
		".*quotaExceeded.*":            "Quota exceeded.",
		".*RESOURCE_EXHAUSTED.*":       "Resource exhausted.",
		".*User Rate Limit Exceeded.*": "User rate limit exceeded.",
		".*does not have enough resources available to fulfill request.*": "GCE resource exhaustion is transient.",

		// 5xx and Internal Server Errors
		".*Error 500.*":    "Internal server error.",
		".*Error 502.*":    "Bad gateway.",
		".*Error 503.*":    "Service unavailable.",
		".*backendError.*": "Backend error.",
		".*Error code 13, message: an internal error has occurred.*": "Internal error.",

		// GKE Cluster update/lock conflicts
		".*Error 400: Cluster is running incompatible operation.*":      "Incompatible operation.",
		".*Error 400.*Master is being updated.*":                        "Master is being updated.",
		".*Error 400.*Cluster is being updated.*":                       "Cluster is being updated.",
		".*Error 400.*Cluster is not ready for operation.*":             "Cluster not ready.",
		".*resource is currently locked as part of another operation.*": "Resource locked.",
		".*NodePool.*was created in the error state.*":                  "Node pool creation failed in error state.",
		".*Cluster.*was created in the error state.*":                   "Cluster creation failed in error state.",

		// Transient IAM / SA replication
		".*Permission.*denied on resource.*":   "IAM permission replication delay.",
		".*Caller is missing IAM permission.*": "IAM permission replication delay.",
		".*serviceAccount.*does not exist.*":   "Service account replication delay.",

		// Transport / Network drops
		".*connection reset by peer.*":       "Connection reset by peer.",
		".*TLS handshake timeout.*":          "TLS handshake timeout.",
		".*transport: Error while dialing.*": "Transport dialing error.",
		".*i/o timeout.*":                    "I/O timeout.",
	}
)

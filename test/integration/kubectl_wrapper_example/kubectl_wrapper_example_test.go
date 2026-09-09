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

package kubectl_wrapper_example

import (
	"fmt"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-gcloud/test/integration/testutils"
)

func TestKubectlWrapperExample(t *testing.T) {
	t.Setenv("CLOUDSDK_CONTAINER_USE_APPLICATION_DEFAULT_CREDENTIALS", "true")

	example := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	example.DefineVerify(func(assert *assert.Assertions) {
		example.DefaultVerify(assert)

		projectID := example.GetStringOutput("project_id")
		clusterName := example.GetStringOutput("cluster_name")
		clusterLocation := example.GetStringOutput("cluster_location")

		locationFlag := "--region"
		if strings.Count(clusterLocation, "-") == 2 {
			locationFlag = "--zone"
		}

		kubeconfigPath := filepath.Join(t.TempDir(), "kubeconfig")
		t.Setenv("KUBECONFIG", kubeconfigPath)

		gcloud.RunCmd(t, fmt.Sprintf("container clusters get-credentials %s --project %s %s %s", clusterName, projectID, locationFlag, clusterLocation))
		k8sOpts := k8s.KubectlOptions{ConfigPath: kubeconfigPath}

		pods := []string{
			"nginx-declarative",
			"nginx-imperative",
			"nginx-fleet-declarative",
			"nginx-fleet-imperative",
		}

		for _, pod := range pods {
			podName := pod
			verifyPod := func() (bool, error) {
				out, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "pod", podName, "-n", "default", "-o", "json")
				if err != nil {
					return true, err
				}
				kubePod := utils.ParseKubectlJSONResult(t, out)
				name := kubePod.Get("metadata.name").String()
				if name != podName {
					return true, fmt.Errorf("expected pod name %s, got %s", podName, name)
				}
				return false, nil
			}
			utils.Poll(t, verifyPod, 10, 5*time.Second)
		}
	})

	example.Test()
}

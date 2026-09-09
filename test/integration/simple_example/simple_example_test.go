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

package simple_example

import (
	"fmt"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-gcloud/test/integration/testutils"
)

func TestSimpleExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	example.DefineVerify(func(assert *assert.Assertions) {
		example.DefaultVerify(assert)

		projectID := example.GetStringOutput("project_id")
		services := gcloud.Run(t, fmt.Sprintf("services list --enabled --project=%s", projectID), gcloud.WithCommonArgs([]string{"--format", "json(config.name)"})).Array()

		var serviceNames []string
		for _, s := range services {
			serviceNames = append(serviceNames, s.Get("config.name").String())
		}

		assert.Contains(serviceNames, "youtube.googleapis.com", "youtube.googleapis.com should be enabled")
		assert.NotContains(serviceNames, "datastore.googleapis.com", "datastore.googleapis.com should not be enabled")
	})

	example.Test()
}

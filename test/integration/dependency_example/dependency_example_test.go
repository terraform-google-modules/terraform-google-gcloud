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

package dependency_example

import (
	"os"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-gcloud/test/integration/testutils"
)

func TestDependencyExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	example.DefineVerify(func(assert *assert.Assertions) {
		example.DefaultVerify(assert)

		filename := example.GetStringOutput("filename")
		data, err := os.ReadFile(filename)
		assert.NoError(err, "should read output file")

		lines := strings.Split(strings.TrimSpace(string(data)), "\n")
		assert.Len(lines, 15, "file should have 15 lines")

		expectedTail := []string{
			"goodbye 1",
			"goodbye 2",
			"goodbye 3",
			"goodbye 4",
			"goodbye 5",
		}
		if len(lines) >= 5 {
			assert.Equal(expectedTail, lines[len(lines)-5:], "last 5 lines should match")
		}
	})

	example.Test()
}

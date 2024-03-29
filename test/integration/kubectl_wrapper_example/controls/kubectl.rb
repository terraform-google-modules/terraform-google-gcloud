# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'kubeclient'
require 'rest-client'

require 'base64'

kubernetes_endpoint = attribute('kubernetes_endpoint')
client_token = attribute('client_token')
ca_certificate = attribute('ca_certificate')

control "kubectl" do
	title "Kubernetes configuration"

	describe "kubernetes" do
		let(:kubernetes_http_endpoint) { "https://#{kubernetes_endpoint}/api" }
		let(:client) do
			cert_store = OpenSSL::X509::Store.new
			cert_store.add_cert(OpenSSL::X509::Certificate.new(Base64.decode64(ca_certificate)))
			Kubeclient::Client.new(
				kubernetes_http_endpoint,
				"v1",
				ssl_options: {
					cert_store: cert_store,
					verify_ssl: OpenSSL::SSL::VERIFY_PEER,
				},
				auth_options: {
					bearer_token: Base64.decode64(client_token),
				},
			)
		end

		describe "pod" do
			describe "nginx-declarative" do
				let(:nginxd) { client.get_pod("nginx-declarative", "default") }

				it "exists" do
					expect(nginxd).not_to be_nil
				end
			end

			describe "nginx-imperative" do
				let(:nginxi) { client.get_pod("nginx-imperative", "default") }

				it "exists" do
					expect(nginxi).not_to be_nil
				end
			end

			describe "nginx-fleet-declarative" do
				let(:nginxd) { client.get_pod("nginx-fleet-declarative", "default") }

				it "exists" do
					expect(nginxd).not_to be_nil
				end
			end

			describe "nginx-fleet-imperative" do
				let(:nginxi) { client.get_pod("nginx-fleet-imperative", "default") }

				it "exists" do
					expect(nginxi).not_to be_nil
				end
			end
		end
	end
end


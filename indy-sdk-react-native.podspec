# Copyright 2019 ABSA Group Limited
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "indy-sdk-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  indy-sdk-react-native
                   DESC
  s.homepage     = "https://github.com/hyperledger/indy-sdk-react-native"
  s.license      = "Apache-2.0"
  # s.license    = { :type => "Apache-2.0", :file => "LICENSE.md" }
  s.authors      = { "Your Name" => "yourname@email.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/hyperledger/indy-sdk-react-native.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = '4.2'

  s.dependency "React"
  s.dependency "Indy"
  # ...
  # s.dependency "..."

  s.pod_target_xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "${PODS_ROOT}/Frameworks" }
end


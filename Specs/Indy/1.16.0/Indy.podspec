Pod::Spec.new do |s|

  s.name         = "Indy"
  s.version      = "1.16.0"
  s.summary      = "Indy SDK iOS Wrapper - SSI Technologies"
  s.homepage     = "https://www.hyperledger.org/use/hyperledger-indy"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Berend Sliedrecht" => "Berend Sliedrecht" }

  s.platform     = :ios, "10.0"

  s.source       = { :http => "https://github.com/hyperledger/indy-sdk-react-native/releases/download/0.2.2/ios-indy-sdk-1.16.0.zip" }
  s.framework    = "Indy"
  s.source_files = "**/*.h"
  s.vendored_frameworks = "IndySdk/Indy.framework"

end
Pod::Spec.new do |s|
  s.name            = 'EngageSDK'
  s.version         = '1.0.1'
  s.summary         = 'Silverpop Engage SDK for iOS.'
  s.homepage        = 'https://github.com/makeandbuild/mobile-connector-sdk-ios'
  s.authors         = { 'Silverpop Development' => 'engineeringmanagement@silverpop.com' }
  s.license         = { :type => 'Apache 2.0', :file => 'License.txt' }
  s.source          = { :git => 'https://github.com/makeandbuild/mobile-connector-sdk-ios', :tag => '1.0.1' }
  s.ios.xcconfig    = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(SDKROOT)/Developer/Library/Frameworks" "$(DEVELOPER_LIBRARY_DIR)/Frameworks"' }
  s.ios.deployment_target = '7.1'
  s.source_files = 'EngageSDK/*/*.{h,m}'
  s.public_header_files = 'EngageSDK/Public/*.h'
  s.requires_arc = true
  s.resources = "Resources/*"

  s.subspec 'AFNetworking' do |net|
      net.dependency 'AFNetworking', '~> 2.2.3'
      net.dependency 'AFOAuth2Client@phoenixplatform', '~> 0.1'
      net.dependency 'MobileDeepLinking-iOS', '~> 0.2'
  end

end

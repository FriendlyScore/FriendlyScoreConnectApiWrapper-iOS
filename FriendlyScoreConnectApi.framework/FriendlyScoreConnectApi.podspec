Pod::Spec.new do |s|
    s.name              = 'FriendlyScoreConnectApi'
    s.version           = '0.1.13'
    s.summary           = 'FriendlyScoreConnectApi for iOS is a wrapper to build custom connectivity flows'
    s.homepage          = 'https://friendlyscore.com'
    s.swift_version     = '4.0'
    s.author            = { 'FriendyScore' => 'info@friendlyscore.com' }
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.platform          = :ios
    s.source            = { :git => 'https://gitlab.friendlyscore.com/mobile/sdkconnectapiios.git', :tag => "#{s.version}"  }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.ios.deployment_target = '12.3'
    s.static_framework = true
      s.dependency 'Alamofire', '~> 4.1'
      s.dependency 'Moya', '~> 13.0.1'
      s.dependency 'ObjectMapper'
    s.ios.vendored_frameworks = 'FriendlyScoreConnectApi.framework'
end


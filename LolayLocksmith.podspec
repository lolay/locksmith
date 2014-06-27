Pod::Spec.new do |s|
    s.name              = 'LolayLocksmith'
    s.version           = '1'
    s.summary           = 'iOS Wrapper for Keychain Utilities such as SecItemCopyMatching, SecItemAdd, SecItemUpdate and SecItemDelete.'
    s.homepage          = 'https://github.com/Lolay/locksmith'
    s.license           = {
        :type => 'Apache',
        :file => 'LICENSE'
    }
    s.author            = {
        'Lolay' => 'support@lolay.com'
    }
    s.source            = {
        :git => 'https://github.com/lolay/locksmith.git',
        :tag => "1"
    }
    s.source_files      = '*.{h,m}'
    s.requires_arc      = true
	s.frameworks = 'Security'
	s.ios.deployment_target = '7.0'
end

platform :ios, '7.0'

target :SHRemoteConfigurationTests do
	pod 'OCMockito', '~> 1.1'
end

post_install do |installer|
    installer.project.targets.each do |target|
        puts target.name
    end
end
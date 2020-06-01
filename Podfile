# Uncomment the next line to define a global platform for your project
# platform :ios, '13.2'
platform :ios, '13.0'

target 'Ahoy' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  
  # Pods for Ahoy
  pod 'NotificationBannerSwift', '~> 3.0.2'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  
  def testing_pods
      pod 'Quick'
      pod 'Nimble'
  end
  
  target 'AhoyTests' do
    inherit! :search_paths
#    testing_pods
  end
  
end

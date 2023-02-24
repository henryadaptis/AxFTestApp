# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'AxFTestApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AxFTestApp
  pod 'Alamofire'
  pod 'ReactiveSwift', '~> 6.7'
  pod 'ReactiveCocoa', '~> 11.2'
  pod 'SnapKit', '~> 5.6.0'  
  pod 'NotificationBannerSwift'

  def testing_pods
      pod 'Quick'
      pod 'Nimble'
  end

  target 'AxFTestAppTests' do
      testing_pods
  end

  target 'AxFTestAppUITests' do
      testing_pods
  end

end

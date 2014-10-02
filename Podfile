platform :ios, '8.0'
pod 'WebViewJavascriptBridge'
#pod 'KSReachability'
pod 'AFPopupView', '~> 1.0'
pod 'ICETutorial', :path => '/Users/philiptolton/ios/ICETutorial'  #:git => 'https://github.com/williamsjj/ICETutorial.git'
pod 'MGInstagram'
pod 'AFNetworking', '~> 1.3.4'
pod 'BFPaperButton', '~> 1.2.7'
pod 'TNSexyImageUploadProgress'
pod 'GoogleAnalytics-iOS-SDK'
pod 'EDStarRating'
#pod 'Analytics'
pod 'FontAwesomeKit/FontAwesome'
pod 'TWRBorderedView'
pod 'KoaPullToRefresh'
pod 'KVOController'
pod 'DBCamera', '~> 2.0'
pod 'ChatHeads', :path => '~/ios/chatheads'
pod 'RestKit', '0.23.1'
#pod 'Appsee'
pod 'CardIO'
pod 'SMPageControl'
pod 'SDWebImage-ProgressView'
pod 'MBProgressHUD', '0.8'
pod 'REFrostedViewController'
pod 'JSONModel'
#pod 'JSONKit', '1.5pre'
pod 'PaymentKit', :path => '~/ios/PaymentKit/' #:git => 'https://github.com/ptolts/PaymentKit.git'
pod 'Stripe', '1.1.3'#, :git => 'https://github.com/stripe/stripe-ios.git'
pod 'Facebook-iOS-SDK' 
#pod 'ALAlertBanner', :path => '~/ios/ALAlertBanner'
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = "$(ARCHS_STANDARD_INCLUDING_64_BIT)"
    end
  end
end

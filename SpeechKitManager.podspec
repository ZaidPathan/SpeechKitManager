#
# Be sure to run `pod lib lint SpeechKitManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SpeechKitManager'
  s.version          = '0.1.3'
  s.summary          = 'Development is in progress.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Development is in progress. Please wait.'
  s.homepage         = 'https://github.com/ZaidPathan/SpeechKitManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zaid Pathan' => 'Zaidkhanintel@gmail.com' }
  s.source           = { :git => 'https://github.com/ZaidPathan/SpeechKitManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ZaidKhanIntel'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SpeechKitManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SpeechKitManager' => ['SpeechKitManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit','Speech'
  # s.dependency 'AFNetworking', '~> 2.3'
end

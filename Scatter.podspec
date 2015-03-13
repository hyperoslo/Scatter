Pod::Spec.new do |s|
  s.name             = "Scatter"
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/hyperoslo/Scatter"
  s.license          = 'MIT'
  s.author           = { "Hyper AS" => "teknologi@hyper.no" }
  s.source           = { :git => "https://github.com/hyperoslo/Scatter.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*'

  s.frameworks = 'UIKit', 'Foundation', 'CoreText'
  
  s.dependency 'Hex'
end

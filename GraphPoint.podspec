Pod::Spec.new do |s|
  s.name = "GraphPoint"
  s.version = "3.1.0"
  s.summary = "A library of Swift extensions for using a Cartesian Coordinate System with CGRect."
  s.description = <<-DESC
  GraphPoint is a library of Swift extensions for using a Cartesian Coordinate System with CGRect.
  The Cartesian Coordinate System defines the origin as the center point and
  it uses several mathematical laws to determine angles and points within a CGRect.
                       DESC
  s.homepage = "https://github.com/richardpiazza/GraphPoint"
  s.license = 'MIT'
  s.author = { "Richard Piazza" => "github@richardpiazza.com" }
  s.social_media_url = 'https://twitter.com/richardpiazza'

  s.source = { :git => "https://github.com/richardpiazza/GraphPoint.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.default_subspec = 'CoreGraphics'
  
  s.subspec 'CoreGraphics' do |framework|
    framework.frameworks = 'CoreGraphics'
    framework.source_files = 'Sources/CoreGraphics/*'
  end

  s.subspec 'Playground' do |framework|
    framework.dependency 'GraphPoint/CoreGraphics'
    framework.frameworks = 'UIKit'
    framework.source_files = 'Sources/Playground/*'
  end
end

Pod::Spec.new do |s|
  s.name = "GraphPoint"
  s.version = "3.2.0"
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
  s.source_files = 'Sources/GraphPoint/*'
  s.swift_version = '4.2'
  s.requires_arc = true
  s.platforms = { :osx => '10.13', :ios => '11.0', :tvos => '11.0', :watchos => '4.0' }
  s.frameworks = 'CoreGraphics'
end

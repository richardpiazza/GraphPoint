Pod::Spec.new do |s|
  s.name = "GraphPoint"
  s.version = "1.0.0"
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
  s.source_files = 'Sources/*'
  s.platform = :ios, '9.1'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end

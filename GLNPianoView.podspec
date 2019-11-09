Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.0.16'
  s.license      = { :type => 'MIT', :file => 'LICENCE.md' }
  s.description  = 'An iOS piano keyboard view, written in Swift. Has an IBInspectable properties and IB_DESIGNABLE preview. Suitable for iPhone or iPad. All image elements are drawn using Core Graphics.'
  s.summary      = 'An iOS piano keyboard view, written in Swift.'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.0.16' }
  s.source_files = 'Source/*.{swift}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
end

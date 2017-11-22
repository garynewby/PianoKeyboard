Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.1.0'
  s.license      = { :type => 'MIT', :file => 'LICENCE.md' }
  s.description  = 'A piano keyboard view, written in Swift. Has an IBInspectable key count property and IB_DESIGNABLE preview. All image elements are drawn using Core Graphics.'
  s.summary      = 'A piano keyboard view, written in Swift.'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com', 'Francisco Bernal' => 'fbernaly@gmail.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.1.0' }
  s.source_files = 'Source/*.{swift}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '9.3'
end

Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.0.11'
  s.license      = { :type => 'MIT', :file => 'LICENCE.md' }
  s.description  = 'A piano keyboard view, written in Swift. Has an IBInspectable key count property and IB_DESIGNABLE preview. All image elements are drawn using Core Graphics.'
  s.summary      = 'A piano keyboard view, written in Swift.'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.0.11' }
  s.source_files = 'Source/*.{swift}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
end

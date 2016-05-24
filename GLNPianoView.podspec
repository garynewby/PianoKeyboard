Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.0.4'
  s.license      = { :type => 'MIT', :file => 'LICENCE.md' }
  s.summary      = 'A piano keyboard view, written in Swift. Has an IBInspectable key count property and IB_DESIGNABLE preview. All image elements drawn via Core Graphics.'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.0.4' }
  s.source_files = 'Source/*.{swift}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
end

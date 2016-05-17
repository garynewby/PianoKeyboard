Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.0.3'
  s.license      = { :type => 'MIT', :file => 'LICENCE.md' }
  s.summary      = 'Piano keyboard instrument view, with variable key count. Images generated with Core Graphics, so works at any resolution.'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.0.3' }
  s.source_files = 'Source/*.{swift}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
end

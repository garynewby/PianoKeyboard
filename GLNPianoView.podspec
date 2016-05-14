Pod::Spec.new do |s|
  s.name         = 'GLNPianoView'
  s.version      = '1.0.0'
  s.license      = { :type => 'custom', :file => 'LICENCE.md' }
  s.summary      = 'GLNPianoView...'
  s.homepage     = 'https://github.com/garynewby/GLNPianoView.git'
  s.authors      = { 'Gary Newby' => 'gary@mellowmuse.com' }
  s.source       = { :git => 'https://github.com/garynewby/GLNPianoView.git', :tag => '1.0.0' }
  s.source_files = 'Source/*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
end

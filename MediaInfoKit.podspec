Pod::Spec.new do |s|
  s.name         = "MediaInfoKit"
  s.version      = "0.0.1"
  s.summary      = "An OS X wrapper of mediainfo lib for Objective-C and Swift projects."
  s.homepage     = "https://github.com/jeremyvizzini/MediaInfoKit/"
  s.license      = 'MIT'
  s.author       = { "Jeremy Vizzini" => "contact@jeremyvizzini.com" }
  s.source       = { :git => "https://github.com/jeremyvizzini/MediaInfoKit.git", :tag => '0.0.1' }
  s.platform     = :osx
  s.requires_arc = true
  s.source_files = 'MediaInfoKit/*.{h,m,mm}', 'MediaInfoLib/Developpers/Include/MediaInfoDLL/MediaInfoDLL.h', 'MediaInfoLib/libmediainfo.0.dylib'
  s.osx.deployment_target = '10.8'
  s.osx.frameworks   = 'Cocoa'
end

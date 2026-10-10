Pod::Spec.new do |s|
  s.name             = 'flutter_open_chinese_convert'
  s.version          = '1.0.1'
  s.summary          = 'Offline Chinese script conversion using OpenCC.'
  s.description      = 'Flutter macOS bridge to SwiftyOpenCC with bundled dictionaries.'
  s.homepage         = 'https://github.com/Regnum-io/flutter_open_chinese_convert'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Weizhong Yang' => 'zonble@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'flutter_open_chinese_convert/Sources/flutter_open_chinese_convert/**/*.swift'
  s.dependency 'FlutterMacOS'
  s.dependency 'OpenCC'
  s.osx.deployment_target = '10.15'
  s.swift_version = '5.0'
end

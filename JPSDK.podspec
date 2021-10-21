Pod::Spec.new do |s|
  s.name     = 'JPSDK'
  s.version  = '0.0.5'
  s.license  = 'BSD'
  s.summary  = 'JPSDK.'
  s.homepage = 'https://github.com/RRRenJ/JPSDK'
  s.author   = { 'RRRenj' => '584201474@qq.com' }
  s.source   = { :git => 'https://github.com/RRRenJ/JPGPUImage.git', :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.prefix_header_file = false
  s.prefix_header_file = 'JPVideoEdit/Base/Model/JPSDK-prefix.pch'
 
  s.source_files = "JPVideoEdit","JPVideoEdit/Base/**/*.{h,m}","JPVideoEdit/Composition/**/*.{h,m}","JPVideoEdit/Filters/**/*.{h,m}","JPVideoEdit/Material/**/*.{h,m}","JPVideoEdit/MaterialDownlaod/**/*.{h,m}","JPVideoEdit/Package/**/*.{h,m}","JPVideoEdit/Transtions/*.{h,m}","JPVideoEdit/Vendors/**/*.{h,m}"
  s.resource = "JPVideoEdit/Resource/JPResource.bundle"
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  
  s.ios.deployment_target = '10.0'
  s.ios.exclude_files = 'Source/Mac'
  s.ios.frameworks   = ['AVFoundation']
  
  s.dependency 'SDCycleScrollView'
  s.dependency 'SDAutoLayout'
  s.dependency 'MBProgressHUD'
  s.dependency 'Masonry'
  s.dependency 'FMDB'
  s.dependency 'MJRefresh'
  s.dependency 'GPUImage'
  
  #s.osx.deployment_target = '10.6'
  #s.osx.exclude_files = 'framework/Source/iOS',
  #                      'framework/Source/GPUImageFilterPipeline.*',
  #                      'framework/Source/GPUImageMovieComposition.*',
  #                      'framework/Source/GPUImageVideoCamera.*',
  #                      'framework/Source/GPUImageStillCamera.*',
  #                      'framework/Source/GPUImageUIElement.*'
  #s.osx.xcconfig = { 'GCC_WARN_ABOUT_RETURN_TYPE' => 'YES' }
  
  
  
end

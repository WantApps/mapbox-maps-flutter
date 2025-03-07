#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mapbox_maps_flutter'
  s.version          = '0.4.0'

  s.summary          = 'Mapbox Maps SDK Flutter Plugin.'
  s.description      = 'An officially developed solution from Mapbox that enables use of our latest Maps SDK product.'
  s.homepage         = 'https://pub.dev/packages/mapbox_maps_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  s.source           = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.resources = ['Assets/**/*']
  s.resource_bundle = { 'mapbox_maps_flutter' => ['Assets/**/*'] }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.dependency 'MapboxMaps', '~> 10.11.1'
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'L10n-swift', '~> 5.10'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.3'
end

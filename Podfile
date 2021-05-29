# Uncomment the next line to define a global platform for your project
platform :ios, '13.4'

target 'RadarChart' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for RadarChart
  pod 'Charts'
  pod 'RealmSwift', '~> 3.18.0'
  pod 'StepSlider', '~> 1.3.0'
  pod 'CropViewController'
  pod 'Firebase/Analytics'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

  target 'RadarChartTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

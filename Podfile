source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'GoogleBooksSearch' do

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'RxAlamofire'

  target 'GoogleBooksSearchTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GoogleBooksSearchUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

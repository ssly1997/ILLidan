#
#  Be sure to run `pod spec lint Illidan.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "Illidan"
  spec.version      = "0.0.1"
  spec.summary      = "swift工具库"

  spec.description  = <<-DESC
                封装了一些简单的工具
                   DESC

  spec.homepage     = "https://github.com/ssly1997/ILLidan"

  spec.license      = "MIT"

  spec.author       = { "lifangchang" => "ssly1997@gmail.com" }

  spec.source       = { :git => "https://github.com/ssly1997/ILLidan.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{swift}"
  spec.exclude_files = "Classes/Exclude"
  
  spec.swift_version = '5.5'
  s.ios.deployment_target = "9.2"
  
end

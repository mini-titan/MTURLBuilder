#
# Be sure to run `pod lib lint MTURLBuilder.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MTURLBuilder"
  s.version          = "0.1.0"
  s.summary          = "A short description of MTURLBuilder."
  s.description      = <<-DESC
                       An optional longer description of MTURLBuilder

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/mini-titan/MTURLBuilder"
  s.license          = 'MIT'
  s.author           = { "mini-titan" => "tatsuro.nekoyama@gmail.com" }
  s.source           = { :git => "https://github.com/mini-titan/MTURLBuilder.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MTURLBuilder' => ['Pod/Assets/*.png']
  }

end

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "roborox-appmetrica"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/roborox/appmetrica.git.git", :tag => "#{s.version}" }


  s.source_files = "ios/**/*.{h,m,mm,swift}"


  s.dependency "React"
  s.dependency "YandexMobileMetrica", "3.17.0"
  s.dependency "YandexMobileMetricaPush", "1.0.0"
end

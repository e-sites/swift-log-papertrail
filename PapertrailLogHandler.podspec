Pod::Spec.new do |s|
  s.name         = "PapertrailLogHandler"
  s.version      = "1.1.1"
  s.author       = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "http://www.e-sites.nl"
  s.summary      = "Papertrail swift-log handler"
  s.source       = { :git => "https://github.com/e-sites/swift-log-papertrail.git", :tag => "v#{s.version}" }
  s.source_files  = "Sources/**/*.{h,swift}"
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.dependency 'Logging'
  s.dependency 'CocoaAsyncSocket'
  s.swift_versions = [ '5.2' ]
end

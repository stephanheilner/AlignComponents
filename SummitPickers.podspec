Pod::Spec.new do |s|
  s.name         = 'SummitPickers'
  s.version      = '1.0.0'
  s.summary      = 'Custom Date and Time Pickers.'
  s.author       = 'Stephan Heilner'
  s.homepage     = 'https://github.com/stephanheilner/SummitPickers'
  s.license      = 'MIT'

  s.description  = <<-DESC
                   SummitPickers are a collection of custom date and time pickers.
                   DESC

  s.source       = { :git => 'https://github.com/stephanheilner/SummitPickers.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'
  s.tvos.deployment_target = '16.0'
  s.source_files  = 'Sources/*.{swift}'
  s.requires_arc = true
  s.swift_version = '5.9'
end

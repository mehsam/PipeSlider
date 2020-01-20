Pod::Spec.new do |s|
  s.name          = "PipeSlider"
  s.version       = "1.0.0"
  s.summary       = "PipeSlider is piston like slider at any direction."
  s.homepage      = "https://github.com/jane/JaneSliderControl"
  s.license       = 'MIT'
  s.author        = { "Mehdi" => "mehdi@nikoosoft.com" }
  s.platform      = :ios, "9.3"
  s.swift_version = "4.2"
  s.source        = { :git => "https://github.com/mehsam/PipeSlider.git", :tag => "1.0.0" }
  s.source_files  = "PipeSlider/PipeSlider/*.swift"
end

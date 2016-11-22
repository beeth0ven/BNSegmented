Pod::Spec.new do |s|
    s.name = "BNSegmented"
    s.version = "3.0.1"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.summary = "SegmentedViewControlle"
    s.homepage = "https://github.com/beeth0ven/BNSegmented"
    s.author = { "Luo Jie" => "beeth0vendev@gmail.com" }
    s.source = { :git => "https://github.com/beeth0ven/BNSegmented.git", :tag => "#{s.version}"}

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true

    s.source_files = "BNSegmented/Source/*.swift"
    s.resources = "BNSegmented/Source/*.{storyboard}"
end

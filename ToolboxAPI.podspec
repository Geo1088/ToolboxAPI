Pod::Spec.new do |s|
    s.name        = "ToolboxAPI"
    s.version     = "0.1.0"
    s.summary     = "Swift helpers for interfacing with Reddit Moderator Toolbox usernotes and settings."
    s.homepage    = "https://github.com/Geo1088/ToolboxAPI"
    s.license     = { :type => "MIT" }
    s.authors     = { "Geo1088" => "georgej1088@gmail.com" }

    s.requires_arc = true
    s.swift_version = "5.2"
    s.osx.deployment_target = "10.9"
    s.ios.deployment_target = "8.0"
    s.watchos.deployment_target = "3.0"
    s.tvos.deployment_target = "9.0"
    s.source   = { :git => "https://github.com/Geo1088/ToolboxAPI.git", :tag => s.version }
    s.source_files = "Sources/ToolboxAPI/*.swift"

    s.dependency "SwiftyJSON"
    s.dependency "GzipSwift"
end

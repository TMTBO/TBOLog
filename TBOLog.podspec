Pod::Spec.new do |s|
    s.name         = "TBOLog"
    s.version      = "0.0.1"
    s.summary      = "A Loger for swift project"
    s.description  = <<-DESC
    A swift Log framework, work with console and file
    DESC
    
    s.homepage     = "https://github.com/TMTBO/TBOLog"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Tobyo Tenma" => "tmtbo@hotmail.com" }
    
    s.ios.deployment_target = "8.0"
    s.osx.deployment_target = "10.10"
    s.source       = { :git => "https://github.com/TMTBO/TBOLog.git", :tag => "#{s.version}" }
    s.source_files  = "Sources/TBOLog/**/*"

    s.test_spec "Tests" do |ts|
        ts.source_files = "Tests/*.swift"
        ts.dependency 'Quick'
        ts.dependency 'Nimble'
    end
end


Pod::Spec.new do |spec|

  spec.name         = "Activeledger-SDK-IOS"
  spec.version      = "0.1.1"
  spec.summary      = " Activeledger SDK for iOS."

  spec.description  = "Use SDK to GENERATE and ONBOARD keys to Ledger"

  spec.homepage     = "https://github.com/activeledger/SDK-IOS/tree/master/Activeledger-SDK-IOS"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "hamidqureshi" => "hamidqureshi.hq000@gmail.com" }

  spec.source       = { :git => "https://github.com/activeledger/SDK-IOS/tree/master/Activeledger-SDK-IOS", :tag => "#{spec.version}" }

  spec.source_files  = "Activeledger-SDK-IOS/**/*.{h,m}"
 
end

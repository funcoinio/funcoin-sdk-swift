Pod::Spec.new do |s|
  s.name         = "FUNCOIN"
  s.version      = "0.24.1"
  s.summary      = "FUNCOIN SDK implementation in Swift for iOS"

  s.description  = <<-DESC
  FUNCOIN SDK implementation in Swift for iOS, intended for mobile developers of wallets and Dapps.
  DESC

  s.homepage     = "https://github.com/funcoinio/funcoin-sdk-swift"
  s.license      = "MIT"
  s.author       = { "Creature1o1" => "info@funcoin.io" }
  s.source       = { git: "https://github.com/funcoinio/funcoin-sdk-swift.git", tag: "v#{s.version.to_s}" }

  s.swift_version = '5.0'
  s.module_name = 'FUNCOIN'
  s.ios.deployment_target = "10.2"
  s.source_files = "Source/**/*.{h,swift}"
  s.public_header_files = "Source/**/*.{h}"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'SwiftProtobuf', '~> 1.2.0'
  s.dependency "secp256k1.swift", "~> 0.1.4"
  s.dependency 'CryptoSwift', '~> 1.0.0'
  s.dependency 'BigInt', '~> 3.1'
  s.dependency 'PromiseKit', '~> 6.8.4'
end

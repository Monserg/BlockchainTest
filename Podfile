# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'BlockchainTest' do

    pod 'Locksmith'
    pod 'CryptoSwift'
    pod 'secp256k1.swift'
    pod 'Localize-Swift', '~> 2.0'

    # CoreBitcoin
#    pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'

end

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

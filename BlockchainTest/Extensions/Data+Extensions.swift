//
//  Data+Extensions.swift
//  BlockchainTest
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

extension Data {
    var integer: Int {
        return withUnsafeBytes { $0.pointee }
    }
    
    var int32: Int32 {
        return withUnsafeBytes { $0.pointee }
    }
    
    var float: Float {
        return withUnsafeBytes { $0.pointee }
    }
    
    var float80: Float80 {
        return withUnsafeBytes { $0.pointee }
    }
    
    var double: Double {
        return withUnsafeBytes { $0.pointee }
    }
        
//    /// Convert Data([UInt8]) -> String(Hex)
//    var hexString: String {
//        return self.map{ String(format: "%02hhx", $0) }.joined()
//    }
    
    /// Convert Data([UInt8]) -> String
    var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    
    /// Convert Data([UInt8]) -> String(Hex)
    var hexlify: String {
        return self.map{ String(format: "%02hhx", $0) }.joined()
    }

}

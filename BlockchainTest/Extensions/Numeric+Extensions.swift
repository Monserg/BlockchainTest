//
//  Numeric+Extensions.swift
//  BlockchainTest
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

extension Numeric {
    var data: Data {
        var source = self
        // This will return 1 byte for 8-bit, 2 bytes for 16-bit, 4 bytes for 32-bit and 8 bytes for 64-bit binary integers.
        // For floating point types it will return 4 bytes for single-precision, 8 bytes for double-precision and 16 bytes for extended precision.
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
    
    var sha256: Data {
        return self.sha256
    }
}

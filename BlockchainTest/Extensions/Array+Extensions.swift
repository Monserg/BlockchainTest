//
//  Array+Extensions.swift
//  BlockchainTest
//
//  Created by msm72 on 10.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

// FOR [Uint8]
extension Array {
    var string: String {
        let data = Data(bytes: self as! [Byte], count: self.count)
        
        return String(data: data, encoding: .utf8)!
    }
}

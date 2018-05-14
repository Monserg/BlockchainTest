//
//  String+Extensions.swift
//  BlockchainTest
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

extension String {
    func convert(toDateFormat dateFormatType: DateFormatType) -> Date {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self)!
    }
    
    func convert(toIntFromStartByte startIndex: Int, toEndByte endIndex: Int) -> UInt32 {
        // Test value "00ce18271e38c48379c4744702be5202d42b2d23"
        let selfString: [Character]         =   Array(self)
        let selfStringBytesArray: [UInt8]   =   stride(from: 0, to: count, by: 2).compactMap { UInt8(String(selfString[$0..<$0.advanced(by: 2)]), radix: 16) }.reversed()
        let selectedBytesArray: [UInt8]     =   Array(selfStringBytesArray[startIndex..<endIndex])
        let selectedBytesArrayData: Data    =   Data(bytes: selectedBytesArray)
        
        return UInt32(bigEndian: selectedBytesArrayData.withUnsafeBytes { $0.pointee })
    }

    var hexBytes: [Byte] {
        return stride(from: 0, to: count, by: 2).compactMap { Byte(String(Array(self)[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}

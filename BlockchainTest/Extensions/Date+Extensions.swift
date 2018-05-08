//
//  Date+Extensions.swift
//  BlockchainTest
//
//  Created by msm72 on 06.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

public enum DateFormatType: String {
    case expirationDateType         =   "yyyy-MM-dd'T'HH:mm:ss"
}

extension Date {
    func convert(toStringFormat dateFormatType: DateFormatType) -> String {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: self)
    }
}

//
//  Callback.swift
//  Delegation
//
//  Created by msm72 on 24.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct Callback<Input> {
    // MARK: - Properties
    private(set) var callback: ((Input) -> Void)?
    
    
    // MARK: - Custom Functions
    mutating func delegate<Object: AnyObject>(to object: Object, withCallback callback: @escaping (Object, Input) -> Void) {
        self.callback = { [weak object] input in
            guard let object = object else {
                return
            }
            
            callback(object, input)
        }
    }
}

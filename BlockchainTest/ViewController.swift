//
//  ViewController.swift
//  BlockchainTest
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let head_block_number: Int64    =   16032312                                        // 36029 (Steem)
    let head_block_id: String       =   "00f4a238fdbd2d454bf460929e7b3c48d75820e9"      // 20 bytes
    let time: String                =   "2018-04-30T12:45:21"                           // "2016-08-08T12:24:17" (expirationDateType)

//    ResponseAPIDynamicGlobalProperty(id: 0, time: "2018-04-30T12:45:21", head_block_id: "00f4a238fdbd2d454bf460929e7b3c48d75820e9", head_block_number: 16032312)

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Create transaction
        let operationType = OperationType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
//        let operationType = OperationType.vote(fields: (voter: "msm72", author: "yuri-vlad-second", permlink: "sdgsdgsdg234234", weight: 10_000))
        let operation: [Any] = operationType.getFields()
//        let refBlocks = self.getRefBlockValues()

        // TESTED VALUES
        var tx: Transaction = Transaction(ref_block_num:         ref_block_num,
                                          ref_block_prefix:      ref_block_prefix,
                                          expiration:            expiration,
                                          operations:            [operation],
                                          extensions:            [],
                                          signatures:            [])


        
//        var tx = Transaction(ref_block_num:         refBlocks.refBlockNum,
//                             ref_block_prefix:      refBlocks.refBlockPrefix,
//                             expiration:            time,
//                             operations:            [operation],
//                             extensions:            [],
//                             signatures:            [])

        Logger.log(message: "\ntransaction:\n\t\(tx)\n", event: .debug)

        
        // Transaction: serialize & SHA256 & ECC signing
        let errorAPI = tx.serialize(byOperationType: operationType)
        
        guard errorAPI == nil else {
            // Show alert error
            Logger.log(message: "\(errorAPI!.localizedDescription)", event: .error)
            return
        }
        
        // Create POST message
        let id = "1"
        let tx_ref_block_num = tx.ref_block_num
        let tx_ref_block_prefix = tx.ref_block_prefix
        let tx_expiration = tx.expiration
        let tx_voter = ((tx.operations[0] as! [Any])[1] as! [String: Any])["voter"] as! String
        let tx_author = ((tx.operations[0] as! [Any])[1] as! [String: Any])["author"] as! String
        let tx_permlink = ((tx.operations[0] as! [Any])[1] as! [String: Any])["permlink"] as! String
        let tx_weight = ((tx.operations[0] as! [Any])[1] as! [String: Any])["weight"] as! Int64
        let tx_signatures = tx.signatures

        
        let request = "{\"id\":\(id),\"method\":\"call\",\"jsonrpc\":\"2.0\",\"params\":[\"database_api\",\"verify_authority\",[{\"ref_block_num\":\(tx_ref_block_num),\"ref_block_prefix\":\(tx_ref_block_prefix),\"expiration\":\"\(tx_expiration)\",\"operations\":[[\"vote\",{\"voter\":\"\(tx_voter)\",\"author\":\"\(tx_author)\",\"permlink\":\"\(tx_permlink)\",\"weight\":\(tx_weight)}]],\"extensions\":[],\"signatures\":\(tx_signatures)}]]}"
        
        print(request)
        
    }

    
    // MARK: - Custom Functions
    /**
     Create `ref_block_*` parameters.
     
     - Returns: Values of `ref_block_*` parameters.
     
    */
    public func getRefBlockValues() -> (refBlockNum: UInt16, refBlockPrefix: UInt32) {
        /// Create `ref_block_num`: get last 2 bytes of `head_block_number`
        let refBlockNum: UInt16 = UInt16(self.head_block_number & 0xFFFF)
        Logger.log(message: "\nref_block_num:\n\t\(refBlockNum)\n", event: .debug)
        
        /// Create `ref_block_prefix`: get 4 bytes (12...16) of `head_block_id`
        let refBlockPrefix = head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
        Logger.log(message: "\nrefBlockPrefix:\n\t\(refBlockPrefix)\n", event: .debug)

        return (refBlockNum, refBlockPrefix)
    }
}


// MARK: - Extensions
extension Array {
    static func createRandomElements(bySize size: Int) -> [UInt8] {
        return (0..<size).map{ _ in UInt8(arc4random_uniform(UInt32(UInt8.max))) }
    }
}


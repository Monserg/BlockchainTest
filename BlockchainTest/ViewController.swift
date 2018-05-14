//
//  ViewController.swift
//  BlockchainTest
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Create transaction
        let operationType = OperationType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
        let operation: [Any] = operationType.getFields()
        let refBlocks = self.getRefBlockValues()

        // TESTED VALUES
//            {"ref_block_num":27682,"ref_block_prefix":683386140,"expiration":"2018-05-11T10:38:45","operations":[["vote",{"voter":"msm72","author":"yuri-vlad-second","permlink":"sdgsdgsdg234234","weight":10000}]],"extensions":[]}```

        var tx: Transaction = Transaction(ref_block_num:         27682,
                                          ref_block_prefix:      683386140,
                                          expiration:            "2018-05-11T10:38:45",
                                          operations:            [operation],
                                          extensions:            [],
                                          signatures:            [])
        
//        var tx: Transaction = Transaction(ref_block_num:         refBlocks.refBlockNum,
//                                          ref_block_prefix:      refBlocks.refBlockPrefix,
//                                          expiration:            time,
//                                          operations:            [operation],
//                                          extensions:            [],
//                                          signatures:            [])

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
        let refBlockNum: UInt16 = UInt16(head_block_number & 0xFFFF)
        Logger.log(message: "\nref_block_num:\n\t\(refBlockNum)\n", event: .debug)
        
        /// Create `ref_block_prefix`: get 4 bytes (12...16) of `head_block_id`
        let refBlockPrefix = head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
        Logger.log(message: "\nrefBlockPrefix:\n\t\(refBlockPrefix)\n", event: .debug)

        return (refBlockNum, refBlockPrefix)
    }
}

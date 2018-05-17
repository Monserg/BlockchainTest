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
        
        // TODO: - TEST POST REQUEST
        // API `get_dynamic_global_properties`
        broadcast.getDynamicGlobalProperties(completion: { success in
            guard success else {
                // ADD AlertView
                return
            }
            
            // Create operation
            let operationType: OperationType = OperationType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
            let operation: [Any] = operationType.getFields()
            
            // Create tx
            var tx: Transaction = Transaction(withOperations: operation)
            Logger.log(message: "\ntransaction:\n\t\(tx)\n", event: .debug)
            
            // Transaction: serialize & SHA256 & ECC signing
            let errorAPI = tx.serialize(byOperationType: operationType)
            
            guard errorAPI == nil else {
                // Show alert error
                Logger.log(message: "\(errorAPI!.localizedDescription)", event: .error)
                return
            }
            
            // Create POST message
            let requestAPIType = broadcast.preparePOST(requestByMethodType: .verifyAuthorityVote, byTransaction: tx)
            
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
        })
    }
}

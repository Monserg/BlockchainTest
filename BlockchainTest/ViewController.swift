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
        // Create OperationType
        let operationType: OperationType = OperationType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
        
        broadcast.executePOST(byOperationType: operationType, completion: { responseAPIType in
            if  let responseModel = responseAPIType?.responseAPI as? ResponseAPIVerifyAuthorityResult, let result = responseModel.result {
                if responseModel.error == nil {
                    Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
                }
            }
                
            else {
                Logger.log(message: "nresponse ErrorAPI = \((responseAPIType!.responseAPI as! ResponseAPIVerifyAuthorityResult).error!.message)\n", event: .error)
            }
        })
    }
}

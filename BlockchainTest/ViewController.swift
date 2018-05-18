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
        
        // TODO: - TEST CHAIN REQUESTS
        self.testGETRequest()
//        self.testPOSTRequest()
    }
}


extension ViewController {
    /// POST
    func testPOSTRequest() {
        // Create OperationType
        let operationType: OperationAPIType = OperationAPIType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
        
        broadcast.executePOST(byOperationAPIType: operationType, completion: { responseAPIType in
            if let responseModel = responseAPIType?.responseAPI as? ResponseAPIVerifyAuthorityResult, let result = responseModel.result {
                if responseModel.error == nil {
                    Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
                }
            }
                
            else {
                Logger.log(message: "nresponse ErrorAPI = \((responseAPIType!.responseAPI as! ResponseAPIVerifyAuthorityResult).error!.message)\n", event: .error)
            }
        })
    }
    
    
    /// GET
    func testGETRequest() {
        // Create MethodAPIType
        let methodAPIType = MethodAPIType.getAccounts(names: ["inertia"])
        
        // API 'get_accounts'
        broadcast.executeGET(byMethodAPIType: methodAPIType, completion: { responseAPIType in
            if let responseModel = responseAPIType?.responseAPI as? ResponseAPIUserResult, let result = responseModel.result {
                if responseModel.error == nil {
                    Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
                }
            }
                
            else {
                Logger.log(message: "nresponse ErrorAPI = \((responseAPIType!.responseAPI as! ResponseAPIUserResult).error!.message)\n", event: .error)
            }
        })
    }
}

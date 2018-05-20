//
//  RestAPI.swift
//  BlockchainTest
//
//  Created by msm72 on 20.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class RestAPI {
    // MARK: - Properties
    var didExecuteGETRequest = Callback<ResponseAPIType>()
    
    
    // MARK: - Custom Functions
    /// Execute any of `GET` API methods.
    func executeGETRequest(methodAPIType: MethodAPIType) {
        // Create GET message to blockchain
        let requestAPIType = self.prepareGET(requestByMethodType: methodAPIType)
        
        guard let requestMessage = requestAPIType.requestMessage else {
            self.didExecuteGETRequest.callback?((responseAPI: nil, errorAPI: ErrorAPI.requestFailed(message: "GET Request Failed")))
            return
        }
        
        Logger.log(message: "\nrequestAPIType:\n\t\(requestMessage)\n", event: .debug)
        
        // Send GET message to blockchain
        webSocketManager.sendRequest(withType: requestAPIType, completion: { responseAPIType in
            self.didExecuteGETRequest.callback?(responseAPIType)
        })
    }
    
    
    /// Prepare GET API request
    private func prepareGET(requestByMethodType methodType: MethodAPIType) -> RequestAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodType.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        let requestParams           =   requestParamsType.paramsSecond
        
        do {
            // Encode data
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   try jsonEncoder.encode(requestParams)
            let jsonParamsString    =   "[\(String(data: jsonData, encoding: .utf8)!)]"
            
            jsonData                =   try jsonEncoder.encode(requestAPI)
            var jsonString          =   String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "]}", with: ",\(jsonParamsString)]}")
            jsonString              =   jsonString
                .replacingOccurrences(of: "[[[", with: "[[")
                .replacingOccurrences(of: "]]]", with: "]]")
                .replacingOccurrences(of: "[\"nil\"]", with: "]")
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            return (id: codeID, requestMessage: jsonString, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return (id: codeID, requestMessage: nil, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: ErrorAPI.requestFailed(message: "GET Request Failed"))
        }
    }

    
    /// API `get_dynamic_global_properties`
    private func getDynamicGlobalProperties(completion: @escaping (Bool) -> Void) {
        // API `get_dynamic_global_properties`
        let requestAPIType = self.prepareGET(requestByMethodType: .getDynamicGlobalProperties())
        //        Logger.log(message: "\nrequestAPIType =\n\t\(requestAPIType!)", event: .debug)
        
        // Network Layer (WebSocketManager)
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
                //                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
                
                guard   let responseAPI = responseAPIType.responseAPI,
                    let responseAPIResult = responseAPI as? ResponseAPIDynamicGlobalPropertiesResult,
                    let globalProperties = responseAPIResult.result else {
                        //                    Logger.log(message: responseAPIType.errorAPI!.caseInfo.message, event: .error)
                        completion(false)
                        return
                }
                
                //                Logger.log(message: "\nglobalProperties:\n\t\(globalProperties)", event: .debug)
                
                time                =   globalProperties.time.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
                headBlockID         =   globalProperties.head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
                headBlockNumber     =   UInt16(globalProperties.head_block_number & 0xFFFF)
                
                completion(true)
            }
        }
    }
    
    
    /// Generating a unique ID
    private func generateUniqueId() -> Int {
        var generatedID = 0
        
        repeat {
            generatedID = Int(arc4random_uniform(1000))
        } while requestIDs.contains(generatedID)
        
        requestIDs.append(generatedID)
        
        return generatedID
    }

}

//
//  Transaction.swift
//  BlockchainTest
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://github.com/Chainers/Ditch/blob/be57f990860bd8cc0d047d0b0bcd99c526a15f94/Sources/Ditch.Golos/Models/Other/Transaction.cs

import Foundation
import secp256k1
import Locksmith
import CryptoSwift
import SwiftBase58

public typealias TransactionOperationType = [String: [String: Any]]

public struct Transaction {
    // MARK: - Properties
    let ref_block_num: UInt16
    let ref_block_prefix: UInt32
    let expiration: String                              // '2016-08-09T10:06:15'
    var operations: [Any]
    let extensions: [String?]
    var signatures: [String]
    
    
    // MARK: - Custom Functions
    private mutating func deleteOperationCode() {
        for (i, operation) in self.operations.enumerated() {
            if var operations = operation as? [Any] {
                operations.remove(at: 1)
                self.operations[i] = operations
            }
        }
    }
    
    private mutating func add(signature: String) {
        self.signatures.append(signature)
    }
    
    
    /**
     Serialize transaction.
     
     - Parameter method: The name of used API method with needed parameters.
     
     */
    public mutating func serialize(byOperationType operationType: OperationType) -> ErrorAPI? {
        /// Create `serializedBuffer` with `chainID`
        var serializedBuffer = Data()
//        var serializedBuffer: Data = "782a3039b478c839e4cb0c941ff4eaeb7df40bdd68bd441afd444b9da763de12".hexData
//        Logger.log(message: "\nserializedBuffer + chainID:\n\t\(serializedBuffer.hexString)\n", event: .debug)
        
        // Add to buffer `ref_block_num` as `UInt16`
//        let ref_block_num: UInt16 = 15769           // 36029, 15769

        let ref_block_num: UInt16 = self.ref_block_num
        serializedBuffer += ref_block_num.data
        Logger.log(message: "\nserializedBuffer + ref_block_num:\n\t\(serializedBuffer.hexString)\n", event: .debug)

        // Add to buffer `ref_block_prefix` as `UInt32`
//        let ref_block_prefix: UInt32 = 2531029956   // 1164960351, 2531029956
       
        let ref_block_prefix: UInt32 = self.ref_block_prefix
        serializedBuffer += ref_block_prefix.data
        Logger.log(message: "\nserializedBuffer + ref_block_prefix:\n\t\(serializedBuffer.hexString)\n", event: .debug)

        // Add to buffer `expiration` as `UInt32`
//        let expirationDate: String = "2018-04-27T08:34:15".convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
        
        let expirationDate: String = self.expiration.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
        serializedBuffer += expirationDate.hexData
        Logger.log(message: "\nserializedBuffer + expiration:\n\t\(serializedBuffer.hexString)\n", event: .debug)

        // Operations: add to buffer `the actual number of operations`
        let operations = self.operations
        serializedBuffer += self.varint(int: operations.count)
        Logger.log(message: "\nserializedBuffer + operationsCount:\n\t\(serializedBuffer.hexString)\n", event: .debug)

        // Operations
        for operation in operations {
            // Operation: add to buffer `operation type name`
            if let operationArray = operation as? [Any], let operationTypeID = operationArray[1] as? Int {
                // Operations: add to buffer `operation type ID`
                serializedBuffer += self.varint(int: operationTypeID)
                Logger.log(message: "\nserializedBuffer - operationTypeID:\n\t\(serializedBuffer.hexString)\n", event: .debug)

                let keyNames = operationType.getFieldNames(byTypeID: operationTypeID)
 
                // Operations: add to buffer `operation fields`
                if let fields = operationArray[2] as? [String: Any] {
                    for keyName in keyNames {
                        let fieldValue = fields[keyName]
                        
                        if let fieldString = fieldValue as? String {
                            // Length + Type
                            let fieldStringData = fieldString.hexData
                            serializedBuffer += self.varint(int: fieldStringData.count) + fieldStringData
                            Logger.log(message: "\nserializedBuffer - fieldString:\n\t\(serializedBuffer.hexString)\n", event: .debug)
                        }

                        else if let fieldInt = fieldValue as? Int64 {
                            // Value
                            serializedBuffer += UInt16(fieldInt).data
                            Logger.log(message: "\nserializedBuffer - fieldInt:\n\t\(serializedBuffer.hexString)\n", event: .debug)
                        }
                    }
                }
            }
        }
 
        // Extensions: add to buffer `the actual number of operations`
        let extensions = self.extensions
        serializedBuffer += self.varint(int: extensions.count)
        Logger.log(message: "\nserializedBuffer + extensionsCount:\n\t\(serializedBuffer.hexString)\n", event: .debug)

        // Add SHA256
//        let chainid = "782a3039b478c839e4cb0c941ff4eaeb7df40bdd68bd441afd444b9da763de12".data(using: String.Encoding.utf8)!
//        let message = (chainid + serializedBuffer).sha256()
        let message = serializedBuffer.sha256()
        Logger.log(message: "\nmessage = serializedBuffer.sha256:\n\t\(message.string)\n", event: .debug)
        
        // ECC signing
        let errorAPI = signingECC(messageSHA256: [UInt8](message))

//        return nil
        return errorAPI
    }
    
    
    /**
     ECC signing serialized buffer of transaction.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return transaction signatures.
     
     */
    private mutating func signingECC(messageSHA256: [UInt8]) -> ErrorAPI? {
        // ECC signing: create `wifs` for store posting keys
        let wifs = [postingKey]            // Tested value
//        let wifs = ["5Jj6qFdJLGKFFFQbfTwv6JNQmXzCidnjgSFNYKhrgqhzigH4sFp"]
        
        
        // DELETE AFTER TEST
        // Delete stored data from Keychain
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "UserDataInfo")
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
        }
        
        // Save login data to Keychain
        do {
            let postingKey = self.base58Decode(data: wifs[0])
            
            try Locksmith.saveData(data: [ "login": "msm72", "secretKey": postingKey ], forUserAccount: "UserDataInfo")
            Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
        } catch {
            Logger.log(message: "Save Login data to Keychain error.", event: .error)
        }
        
        guard let userDataInfo = Locksmith.loadDataForUserAccount(userAccount: "UserDataInfo"), let postingKey = userDataInfo["secretKey"] as? [UInt8] else {
            return ErrorAPI.signingECCKeychainPostingKeyFailure(message: "Posting key not found.")
        }
        
        Logger.log(message: "\nsigningECC - postingKey:\n\t\(postingKey.toHexString())\n", event: .debug)
        
        var index: Int = 0
        var nonceData: [UInt8]? // extra
        var loopCounter: Int = 0
        var recoveryID: Int32 = 0
        var isRecoverable: Bool = false
        var signature = secp256k1_ecdsa_recoverable_signature()             // sig
        let ctx: OpaquePointer = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
        
        while (!(isRecoverable && isCanonical(signature: signature))) {
            if (loopCounter == 0xff) {
                index += 1
                loopCounter = 0
            }

            if (loopCounter > 0) {
                nonceData = Array<UInt8>.createRandomElements(bySize: 32)   // new byte[32]
                nonceData![0] = UInt8(loopCounter)
            }

            loopCounter += 1
            isRecoverable = (secp256k1_ecdsa_sign_recoverable(ctx, &signature, messageSHA256, postingKey, nil, nonceData) as NSNumber).boolValue
            Logger.log(message: "\nsigningECC - nonceData:\n\t\(String(describing: nonceData?.toHexString()))\n", event: .debug)
            Logger.log(message: "\nsigningECC - sig.data:\n\t\(signature.data))\n", event: .debug)
        }

        var output65: [UInt8] = Array<UInt8>.createRandomElements(bySize: 65)       // new byte[65]
        secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &output65, &recoveryID, &signature)

        // 4 - compressed | 27 - compact
        Logger.log(message: "\nsigningECC - output65-1:\n\t\(output65.toHexString())\n", event: .debug)
        output65[0] = UInt8(recoveryID + 4 + 27)                                // (byte)(recoveryId + 4 + 27)
        Logger.log(message: "\nsigningECC - output65-2:\n\t\(output65.toHexString())\n", event: .debug)

        self.deleteOperationCode()
        self.add(signature: output65.toHexString())
        Logger.log(message: "\ntx - modify:\n\t\(self)\n", event: .debug)
        
        return nil
    }
    
    private func isCanonical(signature: secp256k1_ecdsa_recoverable_signature) -> Bool {
        return  !((signature.data.31 & 0x80) > 0)   &&
                !(signature.data.31 == 0)           &&
                !((signature.data.30 & 0x80) > 0)   &&
                !((signature.data.63 & 0x80) > 0)   &&
                !(signature.data.63 == 0)           &&
                !((signature.data.62 & 0x80) > 0)
    }
    
    private func hexlifyy(bytes: [UInt8]) -> String {
        return bytes.map{ String(format: "%02hhx", $0) }.joined()
    }

}


// MARK: - Transaction extension
extension Transaction {
    private func base58Decode(data: String) -> [UInt8] {
        Logger.log(message: "\ntx - postingKeyString:\n\t\(data)\n", event: .debug)
        let s = SwiftBase58.decode(data)
        let dec = cutLastBytes(source: s, cutCount: 4)
        
        Logger.log(message: "\ntx - postingKeyData:\n\t\(dec.toHexString())\n", event: .debug)
        return cutFirstBytes(source: dec, cutCount: 1)
    }
    
    private func cutLastBytes(source: [UInt8], cutCount: Int) -> [UInt8] {
        var result = source
        result.removeSubrange((source.count - cutCount)..<source.count)
        
        return result
    }
    
    private func cutFirstBytes(source: [UInt8], cutCount: Int) -> [UInt8] {
        var result = source
        result.removeSubrange(0..<cutCount)
        
        return result
    }
    
    /// Convert Int -> Data([UInt8])
    private func varint(int: Int) -> Data {
        var data = Data()
        var n = int
        var hexString = String(format:"%02x", arguments: [n])
        print("hexString = \(hexString)")
        
        while Int(hexString, radix: 16)! >= 0x80 {
            data += UInt8((n & 0x7f) | 0x80).data
            n = n >> 7
            hexString = String(format:"%02x", arguments: [n])
        }
        
        data += Int8(hexString, radix: 16)!.data
        
        return data
    }
}

//
//  Operations.swift
//  BlockchainTest
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  Operation types & codes:
//  https://github.com/GolosChain/golos/issues/259

import Foundation

public typealias OperationVoteFields = (voter: String, author: String, permlink: String, weight: Int64)
public typealias OperationCommentFields = (author: String, permlink: String, maxAaccepted_payout: String, percent_steem_dollars: Int64, allow_votes: Bool, allow_curation_rewards: Bool, extensions: [String: Any])

/// Operation types
public enum OperationType {
    /// In Work
    case vote(fields: OperationVoteFields)
    case comment(fields: OperationCommentFields)
    
    
    /// In Reserve
    /*
    case transfer_operation
    case transfer_to_vesting_operation
    case withdraw_vesting_operation
    case limit_order_create_operation
    case limit_order_cancel_operation
    case feed_publish_operation
    case convert_operation
    case account_create_operation
    case account_update_operation
    case witness_update_operation
    case account_witness_vote_operation
    case account_witness_proxy_operation
    case pow_operation
    case custom_operation
    case report_over_production_operation
    case delete_comment_operation
    case custom_json_operation
    case comment_options_operation
    case set_withdraw_vesting_route_operation
    case limit_order_create2_operation
    case challenge_authority_operation
    case prove_authority_operation
    case request_account_recovery_operation
    case recover_account_operation
    case change_recovery_account_operation
    case escrow_transfer_operation
    case escrow_dispute_operation
    case escrow_release_operation
    case pow2_operation
    case escrow_approve_operation
    case transfer_to_savings_operation
    case transfer_from_savings_operation
    case cancel_transfer_from_savings_operation
    case custom_binary_operation
    case decline_voting_rights_operation
    case reset_account_operation
    case set_reset_account_operation

    /// virtual operations below this point
    case fill_convert_request_operation
    case author_reward_operation
    case curation_reward_operation
    case comment_reward_operation
    case liquidity_reward_operation
    case interest_operation
    case fill_vesting_withdraw_operation
    case fill_order_operation
    case shutdown_witness_operation
    case fill_transfer_from_savings_operation
    case hardfork_operation
    case comment_payout_update_operation
    */
    
    
    /// This method return request parameters from selected enum case.
    func getFields() -> [Any] {
        /// Return array: [ operationName, operationCode, [ operationFieldKey: operationFieldValue ] ]
        switch self {
        case .vote(let operation):
            return  [ "vote", 0,    [
                                        "voter":        operation.voter,
                                        "author":       operation.author,
                                        "permlink":     operation.permlink,
                                        "weight":       operation.weight
                                    ]
                    ]

        case .comment(let operation):
            return  [ "comment", 1, [
                                        "author":                   operation.author,
                                        "permlink":                 operation.permlink,
                                        "maxAaccepted_payout":      operation.maxAaccepted_payout,
                                        "percent_steem_dollars":    operation.percent_steem_dollars,
                                        "allow_votes":              operation.allow_votes,
                                        "allow_curation_rewards":   operation.allow_curation_rewards,
                                        "extensions":               operation.extensions
                                    ]
                    ]
        }
    }
    
    /// This method return sorted array of field key names
    func getFieldNames(byTypeID typeID: Int) -> [String] {
        /// Return array: [ operationFieldKey ]
        switch typeID {
        case 0:
            return [ "voter", "author", "permlink", "weight" ]

        case 1:
            return [ "author", "permlink", "maxAaccepted_payout", "percent_steem_dollars", "allow_votes", "allow_curation_rewards", "extensions" ]
            
        default:
            break
        }
        
        return []
    }
}

//
//  Constants.swift
//  BlockchainTest
//
//  Created by msm72 on 07.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://golos.io/test/@yuri-vlad-second/sdgsdgsdg234234

import Foundation

// Dynamic values
// ResponseAPIDynamicGlobalProperty(id: 0, time: "2018-05-14T15:25:30", head_block_id: "00fad3ee54c33d7b5f62c3eca793cc3549ddfcc7", head_block_number: 16438254)
let head_block_number: Int64            =   16438254
let head_block_id: String               =   "00fad3ee54c33d7b5f62c3eca793cc3549ddfcc7"
let time: String                        =   "2018-05-14T15:25:30"

// Operation values
let voter: String                       =   "msm72"
let author: String                      =   "yuri-vlad-second"
let permlink: String                    =   "sdgsdgsdg234234"
let weight: Int64                       =   10_000

// Keys wifs
let postingKey: String                  =   "5Jj6qFdJLGKFFFQbfTwv6JNQmXzCidnjgSFNYKhrgqhzigH4sFp"
let chainID                             =   "782a3039b478c839e4cb0c941ff4eaeb7df40bdd68bd441afd444b9da763de12"          // Golos.io

// Singletons
let broadcast: Broadcast                =   Broadcast.shared

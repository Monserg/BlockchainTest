//
//  Constants.swift
//  BlockchainTest
//
//  Created by msm72 on 07.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

//  {“id”:14,“method”:“call”,“params”:[“network_broadcast_api”,“broadcast_transaction”,[{“ref_block_num”:51322,“ref_block_prefix”:3809751608,“expiration”:“2018-04-26T08:21:37",“operations”:[[“vote”,{“voter”:“yuri-vlad-second”,“author”:“oksaxa”,“permlink”:“ru--kitaijskaya-czivilizacziya”,“weight”:10000}]],“extensions”:[],“signatures”:[“1c4238aad38a9c0db7ad5b795a170bcf57845b91e16e7bfd8e5c74f83cd6f297210d6f5be26bac6887eea94fea0d26541b63f454af35bb1395d16b90a922ec616f”]}]],“jsonrpc”:“2.0"}
//  подписывалось этим активным ключем - 5K7YbhJZqGnw3hYzsmH5HbDixWP5ByCBdnJxM5uoe9LuMX5rcZV

// Dynamic values
let ref_block_num: UInt16               =   51322
let ref_block_prefix: UInt32            =   3809751608
let expiration: String                  =   "2018-04-26T08:21:37"

// Operation values
let voter: String                       =   "yuri-vlad-second"
let author: String                      =   "oksaxa"
let permlink: String                    =   "ru--kitaijskaya-czivilizacziya"
let weight: Int64                       =   10_000

// Keys wifs
let postingKey: String                  =   "5K7YbhJZqGnw3hYzsmH5HbDixWP5ByCBdnJxM5uoe9LuMX5rcZV"

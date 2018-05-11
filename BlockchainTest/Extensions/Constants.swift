//
//  Constants.swift
//  BlockchainTest
//
//  Created by msm72 on 07.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// Alex
//  {“id”:14,“method”:“call”,“params”:[“network_broadcast_api”,“broadcast_transaction”,[{“ref_block_num”:51322,“ref_block_prefix”:3809751608,“expiration”:“2018-04-26T08:21:37",“operations”:[[“vote”,{“voter”:“yuri-vlad-second”,“author”:“oksaxa”,“permlink”:“ru--kitaijskaya-czivilizacziya”,“weight”:10000}]],“extensions”:[],“signatures”:[“1c4238aad38a9c0db7ad5b795a170bcf57845b91e16e7bfd8e5c74f83cd6f297210d6f5be26bac6887eea94fea0d26541b63f454af35bb1395d16b90a922ec616f”]}]],“jsonrpc”:“2.0"}

// Yuriy (рабочий вариант)
//{"id":1,"method":"call","jsonrpc":"2.0","params":["database_api","verify_authority",[{"ref_block_num":58100,"ref_block_prefix":4122522244,"expiration":"2018-04-26T14:03:24","operations":[["vote",{"voter":"yuri-vlad","author":"yuri-vlad-second","permlink":"sdsffs1211","weight":10000}]],"extensions":[],"signatures":["1b2a59fe71998a805fd0bbd325395b7e4a1c69eeebc724d955920678c6e23df86f355f388eca938998b4b894ce19b0c6b1c687567a97398fa15f536e01e4c60e06"]}]]}

//  подписывалось этим активным ключем - 5K7YbhJZqGnw3hYzsmH5HbDixWP5ByCBdnJxM5uoe9LuMX5rcZV


// Dynamic values
let isAlex                              =   false

//    ResponseAPIDynamicGlobalProperty(id: 0, time: "2018-04-30T12:45:21", head_block_id: "00f4a238fdbd2d454bf460929e7b3c48d75820e9", head_block_number: 16032312)
let head_block_number: Int64            =   16032312
let head_block_id: String               =   "00f4a238fdbd2d454bf460929e7b3c48d75820e9"
let time: String                        =   "2018-04-30T12:45:21"

let ref_block_num: UInt16               =   (isAlex) ? 51322 : 58100
let ref_block_prefix: UInt32            =   (isAlex) ? 3809751608 : 4122522244
let expiration: String                  =   (isAlex) ? "2018-04-26T08:21:37" : "2018-04-26T14:03:24"

// Operation values
let voter: String                       =   (isAlex) ? "yuri-vlad-second" : "yuri-vlad"
let author: String                      =   (isAlex) ? "oksaxa" : "yuri-vlad-second"
let permlink: String                    =   (isAlex) ? "ru--kitaijskaya-czivilizacziya" : "sdsffs1211"
let weight: Int64                       =   10_000

// Keys wifs
let postingKey: String                  =   "5K7YbhJZqGnw3hYzsmH5HbDixWP5ByCBdnJxM5uoe9LuMX5rcZV"

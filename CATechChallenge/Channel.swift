//
//  Channel.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import Foundation

struct Channel: Codable {
    let id: String
    let name: String
    let url: String
}

extension Channel {
    struct ApiChannels: Codable {
        let channels: [Channel]
    }
}

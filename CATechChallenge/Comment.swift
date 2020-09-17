//
//  Comment.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let id: String
    let userId: String
    let message: String
    let createdAt: Date
}

extension Comment {
    struct ApiComments: Codable {
        let comments: [Comment]
    }
}


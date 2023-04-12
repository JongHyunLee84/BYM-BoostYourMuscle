//
//  ServerEntity.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import Foundation

struct ServerEntity: Codable {
    let bodyPart: String
    let equipment: String
    let gifURL: String
    let id, name: String
    let target: String

    enum CodingKeys: String, CodingKey {
        case bodyPart, equipment
        case gifURL = "gifUrl"
        case id, name, target
    }
}

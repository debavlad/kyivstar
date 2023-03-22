//
//  Category.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Category: Codable, Hashable {
    var id: String?
    var name: String
    var image: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
    }
}

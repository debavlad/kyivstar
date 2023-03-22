//
//  Promotion.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Promotion: Codable, Hashable {
    var id: String?
    var name: String?
    var image: String
    var company: String?
    var updatedAt: String?
    var releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, company, updatedAt, releaseDate
    }
}

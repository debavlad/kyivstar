//
//  Asset.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Asset: Codable, Hashable {
    var id: String?
    var name: String
    var image: String?
    var company: String?
    var progress: Int?
    var purchased: Bool?
    var updatedAt: String?
    var releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, company, progress, purchased, updatedAt, releaseDate
    }
}

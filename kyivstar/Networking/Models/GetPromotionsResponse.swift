//
//  GetPromotionsResponse.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import Foundation

struct GetPromotionsResponse: Codable {
    let id: String
    let name: String
    let promotions: [Promotion]
}

//
//  Item.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

enum Item: Hashable {
    case promotion(Promotion)
    case category(Category)
    case novelty(Asset)
    case children(Asset)
    case educational(Asset)
}

struct Section: Hashable {
    let items: [Item]
    let title: String?
}

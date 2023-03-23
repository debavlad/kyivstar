//
//  Item.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Item: Hashable {
    let title: String
    let image: String?
    var purchased: Bool?
    var description: String?
}


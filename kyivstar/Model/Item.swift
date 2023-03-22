//
//  Item.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Item: Hashable {
    let id: UUID
    let title: String?

    init(title: String?) {
        self.id = UUID()
        self.title = title
    }
}

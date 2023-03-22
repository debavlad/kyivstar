//
//  Section.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

struct Section: Hashable {
    let id: UUID
    let title: String
    let items: [Item]

    init(title: String, items: [Item]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }
}

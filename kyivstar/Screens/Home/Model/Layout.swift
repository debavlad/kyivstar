//
//  Section.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation

enum Layout: Int, CaseIterable {
    case promotions
    case categories
    case novelties
    case children
    case educational

    var title: String? {
        switch self {
        case .categories:
            return "Категорії"
        case .novelties:
            return "Новинки Київстар ТБ"
        case .children:
            return "Дитячі телеканали"
        case .educational:
            return "Пізнавальні"
        default:
            return nil
        }
    }
}

//
//  GetContentGroupsResponse.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import Foundation

typealias GetContentGroupsResponse = [ContentGroup]

struct ContentGroup: Codable {
    enum Subtype: String, Codable {
        case movie = "MOVIE"
        case liveChannel = "LIVECHANNEL"
        case series = "SERIES"
        case epg = "EPG"
    }

    let id: String
    let name: String
    let type: [Subtype]
    let assets: [Asset]
    let canBeDeleted: Bool
}

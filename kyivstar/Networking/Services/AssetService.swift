//
//  AssetService.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import Foundation

protocol AssetServiceProtocol {
    func getPromotions() async throws -> Snapshot
    func getCategories() async throws -> Snapshot
    func getContentGroups() async throws -> [Snapshot]
}

class AssetService: AssetServiceProtocol {
    private let repository: AssetRepositoryProtocol

    init(repository: AssetRepositoryProtocol = AssetRepository()) {
        self.repository = repository
    }

    func getPromotions() async throws -> Snapshot {
        let response = try await repository.getPromotions()
        let section = Section(title: response.name, layout: .promotions)
        return Snapshot(section: section,
                        items: response.promotions.map {
            Item(title: $0.name, image: $0.image)
        })
    }

    func getCategories() async throws -> Snapshot {
        let response = try await repository.getCategories()
        let section = Section(title: "Categories", layout: .categories)
        return Snapshot(section: section,
                        items: response.categories.map {
            Item(title: $0.name, image: $0.image)
        })
    }

    func getContentGroups() async throws -> [Snapshot] {
        let response = try await repository.getContentGroups()

        var movieSeriesGroup: [ContentGroup] = []
        var tvChannelGroup: [ContentGroup] = []
        var epgGroup: [ContentGroup] = []

        for group in response {
            guard let type = group.type.first else { continue }
            switch type {
            case .movie, .series:
                movieSeriesGroup.append(group)
            case .liveChannel:
                tvChannelGroup.append(group)
            case .epg:
                epgGroup.append(group)
            }
        }

        var snapshots: [Snapshot] = []

        movieSeriesGroup.forEach { group in
            let section = Section(title: group.name, layout: .movieSeries, canBeDeleted: group.canBeDeleted)
            let snapshot = Snapshot(
                section: section,
                items: group.assets.map {
                    Item(title: $0.name, image: $0.image, purchased: $0.purchased, progress: $0.progress)
                })
            snapshots.append(snapshot)
        }

        tvChannelGroup.forEach { group in
            let section = Section(title: group.name, layout: .liveChannel, canBeDeleted: group.canBeDeleted)
            let snapshot = Snapshot(
                section: section,
                items: group.assets.map {
                    Item(title: $0.name, image: $0.image, purchased: $0.purchased)
                })
            snapshots.append(snapshot)
        }

        epgGroup.forEach { group in
            let section = Section(title: group.name, layout: .epg, canBeDeleted: group.canBeDeleted)
            let snapshot = Snapshot(
                section: section,
                items: group.assets.map {
                    Item(title: $0.name, image: $0.image, purchased: $0.purchased, description: $0.company)
                })
            snapshots.append(snapshot)
        }

        return snapshots
    }
}

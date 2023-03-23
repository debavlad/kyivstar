//
//  GeneratorService.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import Foundation

protocol GeneratorServiceProtocol {
    func getPromotions(completion: @escaping (Snapshot) -> Void)
    func getCategories(completion: @escaping (Snapshot) -> Void)
    func getContentGroups(completion: @escaping ([Snapshot]) -> Void)
}

class GeneratorService: GeneratorServiceProtocol {
    private let repository: GeneratorRepositoryProtocol

    init(repository: GeneratorRepositoryProtocol = GeneratorRepository()) {
        self.repository = repository
    }

    func getPromotions(completion: @escaping (Snapshot) -> Void) {
        repository.getPromotions { response in
            let section = Section(title: response.name, layout: .promotions)
            let snapshot = Snapshot(
                section: section,
                items: response.promotions.map {
                    Item(title: $0.name, image: $0.image)
                })
            completion(snapshot)
        }
    }

    func getCategories(completion: @escaping (Snapshot) -> Void) {
        repository.getCategories { response in
            let section = Section(title: "Categories", layout: .categories)
            let snapshot = Snapshot(
                section: section,
                items: response.categories.map {
                    Item(title: $0.name, image: $0.image)
                })
            completion(snapshot)
        }
    }

    func getContentGroups(completion: @escaping ([Snapshot]) -> Void) {
        repository.getContentGroups { response in
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
                let section = Section(title: group.name, layout: .movieSeries)
                let snapshot = Snapshot(
                    section: section,
                    items: group.assets.map {
                        Item(title: $0.name, image: $0.image, purchased: $0.purchased)
                    })
                snapshots.append(snapshot)
            }

            tvChannelGroup.forEach { group in
                let section = Section(title: group.name, layout: .liveChannel)
                let snapshot = Snapshot(
                    section: section,
                    items: group.assets.map {
                        Item(title: $0.name, image: $0.image, purchased: $0.purchased)
                    })
                snapshots.append(snapshot)
            }

            epgGroup.forEach { group in
                let section = Section(title: group.name, layout: .epg)
                let snapshot = Snapshot(
                    section: section,
                    items: group.assets.map {
                        Item(title: $0.name, image: $0.image, purchased: $0.purchased)
                    })
                snapshots.append(snapshot)
            }

            completion(snapshots)
        }
    }
}

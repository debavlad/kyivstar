//
//  HomeViewModel.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit
import Combine

class HomeViewModel {
    @Published var promotions: [Promotion] = []
    @Published var categories: [Category] = []
    @Published var novelties: [Asset] = []
    @Published var children: [Asset] = []
    @Published var educational: [Asset] = []

    private let repository: GeneratorRepositoryProtocol = GeneratorRepository()

    private var cancellables: Set<AnyCancellable> = []

    func setupDataSource(for collectionView: UICollectionView) {
        let source: UICollectionViewDiffableDataSource<Layout, Item> = .init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
            switch item {
            case .promotion(let promotion):
                let cell: PromotionCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: promotion)
                return cell
            case .category(let category):
                let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: category)
                return cell
            case .novelty(let asset):
                let cell: NoveltyCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: asset)
                return cell
            case .children(let asset):
                let cell: ChildrenCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: asset)
                return cell
            case .educational(let asset):
                let cell: EducationalCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: asset)
                return cell
            }
        }

        source.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView
            if let title = Layout(rawValue: indexPath.section)?.title {
                header?.configure(with: title, section: indexPath.section, delegate: nil)
            }
            return header!
        }

        let assets = Publishers.CombineLatest3($novelties, $children, $educational)
        $promotions.combineLatest($categories, assets)
            .sink(receiveValue: { result in
                var snapshot = NSDiffableDataSourceSnapshot<Layout, Item>()
                snapshot.appendSections([.promotions, .categories, .novelties, .children, .educational])
                snapshot.appendItems(result.0.map { Item.promotion($0) }, toSection: .promotions)
                snapshot.appendItems(result.1.map { Item.category($0) }, toSection: .categories)
                snapshot.appendItems(result.2.0.map { Item.novelty($0) }, toSection: .novelties)
                snapshot.appendItems(result.2.1.map { Item.children($0) }, toSection: .children)
                snapshot.appendItems(result.2.2.map { Item.educational($0) }, toSection: .educational)
                source.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancellables)
    }

    func asset(for indexPath: IndexPath) -> Asset? {
        switch Layout(rawValue: indexPath.section) {
        case .novelties:
            return novelties[indexPath.item]
        case .children:
            return children[indexPath.item]
        case .educational:
            return educational[indexPath.item]
        default:
            return nil
        }
    }

    func fetchData() {
        repository.getPromotions { [weak self] response in
            self?.promotions = response.promotions
        }
        repository.getCategories { [weak self] response in
            self?.categories = response.categories
        }
        repository.getContentGroups { [weak self] response in
            self?.novelties = response
                .filter { $0.type.contains(.movie) || $0.type.contains(.series) }
                .flatMap { $0.assets }

            self?.children = response
                .filter { $0.type.contains(.liveChannel) }
                .flatMap { $0.assets }

            self?.educational = response
                .filter { $0.type.contains(.epg) }
                .flatMap { $0.assets }
        }
    }
}

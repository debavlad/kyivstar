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

        $promotions.combineLatest($categories)
            .sink { [weak self] promotions, categories in
                var snapshot = NSDiffableDataSourceSnapshot<Layout, Item>()
                snapshot.appendSections([.promotions])
                snapshot.appendItems(promotions.map { Item.promotion($0) }, toSection: .promotions)
                snapshot.appendSections([.categories])
                snapshot.appendItems(categories.map { Item.category($0) }, toSection: .categories)
                source.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }

    func fetchData() {
        promotions = [
            Promotion(image: "2"),
            Promotion(image: "1")
        ]
        categories = [
            Category(name: "Test 1", image: ""),
            Category(name: "Test 2", image: ""),
            Category(name: "Test 3", image: ""),
            Category(name: "Test 4", image: "")
        ]
        novelties = [
            Asset(name: "Test 1", image: ""),
            Asset(name: "Test 2", image: ""),
            Asset(name: "Test 3", image: ""),
            Asset(name: "Test 4", image: "")
        ]
        children = [
            Asset(name: "Test 1", image: ""),
            Asset(name: "Test 2", image: ""),
            Asset(name: "Test 3", image: ""),
            Asset(name: "Test 4", image: "")
        ]
        educational = [
            Asset(name: "Test 1", image: ""),
            Asset(name: "Test 2", image: ""),
            Asset(name: "Test 3", image: "")
        ]
    }
}

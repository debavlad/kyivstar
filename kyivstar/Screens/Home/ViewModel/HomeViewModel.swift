//
//  HomeViewModel.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit
import Combine

protocol LayoutProviding {
    func layout(for sectionIndex: Int) -> Layout
}

class HomeViewModel: NSObject {
    private weak var coordinator: HomeCoordinator?

    @Published var snapshots: [Snapshot] = []
    private(set) var sections: [Section] = []

    private let service: GeneratorServiceProtocol = GeneratorService()
    private var cancellables: Set<AnyCancellable> = []

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func setupDataSource(for collectionView: UICollectionView) {
        let source: UICollectionViewDiffableDataSource<Section, Item> = .init(
            collectionView: collectionView) { collectionView, indexPath, item in
                switch self.sections[indexPath.section].layout {
                case .promotions:
                    let cell: PromotionCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .categories:
                    let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .movieSeries:
                    let cell: NoveltyCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .liveChannel:
                    let cell: ChildrenCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .epg:
                    let cell: EducationalCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                }
        }

        source.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView
            let title = self.sections[indexPath.section].title
            header?.configure(with: title, section: indexPath.section, delegate: nil)
            return header!
        }

        $snapshots.sink { completion in
            print(completion)
        } receiveValue: { [weak self] snapshots in
            guard let self else { return }
            DispatchQueue.main.async {
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                let sections = snapshots.map { $0.section }
                snapshot.appendSections(sections)
                self.sections = sections
                snapshots.forEach {
                    snapshot.appendItems($0.items, toSection: $0.section)
                }
                source.apply(snapshot)
            }
        }
        .store(in: &cancellables)
    }

    func fetchData() {
        let group = DispatchGroup()

        group.enter()
        service.getContentGroups { [weak self] in
            self?.snapshots.append(contentsOf: $0)
            group.leave()
        }

        group.enter()
        service.getCategories { [weak self] in
            self?.snapshots.append($0)
            group.leave()
        }

        group.enter()
        service.getPromotions { [weak self] in
            self?.snapshots.append($0)
            group.leave()
        }

        group.notify(queue: .main) {
            print("Done!")
        }
    }
}

extension HomeViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = snapshots[indexPath.section].items[indexPath.item]
        coordinator?.goToAsset(item)
    }
}

extension HomeViewModel: LayoutProviding {
    func layout(for sectionIndex: Int) -> Layout {
        sections[sectionIndex].layout
    }
}

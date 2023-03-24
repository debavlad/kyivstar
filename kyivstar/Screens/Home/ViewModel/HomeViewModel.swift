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

    private let service: AssetServiceProtocol = AssetService()
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
                    let cell: MovieCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .liveChannel:
                    let cell: ChannelCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                case .epg:
                    let cell: EPGCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: item)
                    return cell
                }
        }

        source.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderView else {
                return UICollectionReusableView()
            }

            let section = self.sections[indexPath.section]
            header.configure(with: section.title,
                             canBeDeleted: section.canBeDeleted ?? false)
            header.deleteCallback = { [weak self] in
                self?.snapshots.removeAll { $0.section.title == section.title }
            }
            return header
        }

        $snapshots.sink { completion in
            print(completion)
        } receiveValue: { [weak self] snapshots in
            guard let self else { return }
            DispatchQueue.main.async {
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                let sections = snapshots
                    .sorted { $0.section.layout.rawValue < $1.section.layout.rawValue}
                    .map { $0.section }
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
        Task {
            try await withThrowingTaskGroup(of: [Snapshot].self) {
                var snapshots: [Snapshot] = []

                $0.addTask { try await [self.service.getPromotions()] }
                $0.addTask { try await [self.service.getCategories()] }
                $0.addTask { try await self.service.getContentGroups() }

                for try await snapshot in $0 {
                    snapshots.append(contentsOf: snapshot)
                }

                self.snapshots = snapshots.sorted {
                    $0.section.layout.rawValue < $1.section.layout.rawValue
                }
                return snapshots
            }
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

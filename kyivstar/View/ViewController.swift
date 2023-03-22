//
//  ViewController.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(cell: ItemCollectionViewCell.self)
        view.register(header: SectionHeaderView.self)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: collectionView) { (collectionView, indexPath, item) -> ItemCollectionViewCell? in
            collectionView.dequeue(for: indexPath)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header?.configure(with: section.title, section: indexPath.section, delegate: self)
            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sections = [
            Section(title: "Categories", items: (1...5).map { Item(title: "Item \($0)") }),
            Section(title: "New", items: (1...5).map { Item(title: "Item \($0)") }),
            Section(title: "Children", items: (1...5).map { Item(title: "Item \($0)") })
        ]
        snapshot.appendSections(sections)

        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot)
    }
}

extension ViewController: SectionHeaderDelegate {
    func deleteButtonTapped(in section: Int) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([snapshot.sectionIdentifiers[section]])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

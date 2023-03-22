//
//  HomeViewController.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController {
    static let categoryHeaderId = "categoryHeaderId"
    let headerId = "headerId"

    lazy var source: UICollectionViewDiffableDataSource<Layout, Item> = .init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
        switch item {
        case .promotion(let promotion):
            let cell: UICollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.backgroundColor = .red
            cell.layer.cornerRadius = 24
            return cell
        case .category(let category):
            let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: category.name)
            return cell
        case .novelty(let asset):
            let cell: NoveltyCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: asset.name)
            return cell
        case .children(let asset):
            let cell: ChildrenCollectionViewCell = collectionView.dequeue(for: indexPath)
            //...
            return cell
        case .educational(let asset):
            let cell: UICollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.backgroundColor = .red
            cell.layer.cornerRadius = 24
            return cell
        }
    }

    init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let layout = Layout(rawValue: sectionIndex)
            switch layout {
            case .promotions:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                return section
            case .categories:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/2.7)))
                item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(160)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: Self.categoryHeaderId, alignment: .top)
                ]
                return section
            case .novelties:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/1.8)))
                item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(160)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: Self.categoryHeaderId, alignment: .top)
                ]
                return section
            case .children:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: Self.categoryHeaderId, alignment: .top)
                ]
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)))
                item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(160)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: Self.categoryHeaderId, alignment: .top)
                ]
                return section
            }
        }
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupDataSource()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(cell: UICollectionViewCell.self)
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: NoveltyCollectionViewCell.self)
        collectionView.register(cell: ChildrenCollectionViewCell.self)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: Self.categoryHeaderId, withReuseIdentifier: headerId)
    }

    private func setupNavigationBar() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 104))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo")
        navigationItem.titleView = imageView
    }

    private func setupDataSource() {
        source.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: Self.categoryHeaderId, withReuseIdentifier: self.headerId, for: indexPath) as? SectionHeaderView
            if let title = Layout(rawValue: indexPath.section)?.title {
                header?.configure(with: title, section: indexPath.section, delegate: self)
            }
            return header!
        }

        var snapshot = source.snapshot()
        snapshot.appendSections([.promotions, .categories, .novelties, .children, .educational])
        snapshot.appendItems([
            .promotion(Promotion(image: "2")),
            .promotion(Promotion(image: "1"))
        ], toSection: .promotions)
        snapshot.appendItems([
            .category(Category(name: "Test 1", image: "")),
            .category(Category(name: "Test 2", image: "")),
            .category(Category(name: "Test 3", image: "")),
            .category(Category(name: "Test 4", image: ""))
        ], toSection: .categories)
        snapshot.appendItems([
            .novelty(Asset(name: "Test 1", image: "")),
            .novelty(Asset(name: "Test 2", image: "")),
            .novelty(Asset(name: "Test 3", image: "")),
            .novelty(Asset(name: "Test 4", image: ""))
        ], toSection: .novelties)
        snapshot.appendItems([
            .children(Asset(name: "Test 1", image: "")),
            .children(Asset(name: "Test 2", image: "")),
            .children(Asset(name: "Test 3", image: "")),
            .children(Asset(name: "Test 4", image: ""))
        ], toSection: .children)
        snapshot.appendItems([
            .educational(Asset(name: "Test 1", image: "")),
            .educational(Asset(name: "Test 2", image: "")),
            .educational(Asset(name: "Test 3", image: ""))
        ], toSection: .educational)
        source.apply(snapshot)
    }
}

extension HomeViewController: SectionHeaderDelegate {
    func deleteButtonTapped(in section: Int) {
        //...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }

    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: HomeViewController())
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            //...
        }

        typealias UIViewControllerType = UIViewController
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

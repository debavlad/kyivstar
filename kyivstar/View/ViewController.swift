//
//  ViewController.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit
import SwiftUI

enum Section: Int, CaseIterable {
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

class ViewController: UICollectionViewController {
    static let categoryHeaderId = "categoryHeaderId"
    let headerId = "headerId"

    init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section(rawValue: sectionIndex)
            switch section {
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
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: Self.categoryHeaderId, withReuseIdentifier: headerId, for: indexPath) as? SectionHeaderView
        if let title = Section(rawValue: indexPath.section)?.title {
            header?.configure(with: title, section: indexPath.section, delegate: self)
        }
        return header!
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .categories:
            let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: "Мультфільми")
            return cell
        case .novelties:
            let cell: NoveltyCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: "За садовим парканом")
            return cell
        case .children:
            let cell: ChildrenCollectionViewCell = collectionView.dequeue(for: indexPath)
            return cell
        default:
            let cell: UICollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.backgroundColor = .red
            cell.layer.cornerRadius = 24
            return cell
        }
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
}

extension ViewController: SectionHeaderDelegate {
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
            UINavigationController(rootViewController: ViewController())
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

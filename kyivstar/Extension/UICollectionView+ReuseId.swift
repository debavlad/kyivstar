//
//  UICollectionView+ReuseId.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(header: T.Type) {
        register(T.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

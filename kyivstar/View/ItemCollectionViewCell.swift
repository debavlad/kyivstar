//
//  ItemCollectionViewCell.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 20
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8)
        ])
    }
}

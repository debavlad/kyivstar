//
//  CategoryCollectionViewCell.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        titleLabel.text = item.title

        guard let image = item.image,
              let url = URL(string: image) else { return }

        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.25))
            ])
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }
}

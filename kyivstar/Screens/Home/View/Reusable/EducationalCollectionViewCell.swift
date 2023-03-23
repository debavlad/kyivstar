//
//  EducationalCollectionViewCell.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class EducationalCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()

    private let lockImageView: UIImageView = {
        let image = UIImage(named: "Lock")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        titleLabel.text = item.title
        subtitleLabel.text = item.description
        lockImageView.isHidden = item.purchased ?? false
        
        guard let image = item.image,
              let url = URL(string: image) else { return }

        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.25))
            ])
    }

    private func setupSubviews() {
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-2)
        }

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }

        addSubview(lockImageView)
        lockImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.leading.top.equalToSuperview().inset(8)
        }
    }
}

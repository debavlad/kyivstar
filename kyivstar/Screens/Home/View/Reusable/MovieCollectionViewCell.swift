//
//  MovieCollectionViewCell.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private let lockImageView: UIImageView = {
        let image = UIImage(named: "Lock")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .dodgerBlue
        view.backgroundColor = .gunmetal
        view.isHidden = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
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
        lockImageView.isHidden = item.purchased ?? false

        if let progress = item.progress, progress > 0 {
            progressView.progress = Float(progress)/100
            progressView.isHidden = false
        }

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

        imageView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }

        addSubview(lockImageView)
        lockImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.leading.top.equalToSuperview().inset(8)
        }
    }
}


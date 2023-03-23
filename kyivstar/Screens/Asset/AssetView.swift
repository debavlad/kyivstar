//
//  AssetView.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import UIKit

class AssetView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()

    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 20
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "The SpongeBob Movie: Sponge on the Run"
        label.numberOfLines = 0
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
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.6)
        }

        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }

        addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.width.equalTo(70)
            $0.height.equalTo(40)
        }

        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

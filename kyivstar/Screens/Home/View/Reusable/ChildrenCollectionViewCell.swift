//
//  ChildrenCollectionViewCell.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class ChildrenCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray5
        view.layer.masksToBounds = true
        return view
    }()

    private let lockImageView: UIImageView = {
        let image = UIImage(named: "Lock")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = frame.width/2
    }

    func configure(with item: Item) {
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
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        addSubview(lockImageView)
        lockImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.leading.top.equalToSuperview()
        }
    }
}



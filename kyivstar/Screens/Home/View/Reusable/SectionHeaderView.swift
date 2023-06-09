//
//  SectionHeaderView.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    var deleteCallback: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .trailing
        button.setTitle("Del", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, canBeDeleted: Bool) {
        titleLabel.text = title
        deleteButton.isHidden = !canBeDeleted
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
    }

    @objc private func deleteButtonTapped() {
        deleteCallback?()
    }
}

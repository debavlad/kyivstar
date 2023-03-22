//
//  SectionHeaderView.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func deleteButtonTapped(in section: Int)
}

class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    let deleteButton = UIButton()

    weak var delegate: SectionHeaderDelegate?
    private var section: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.setTitle("Del", for: .normal)
        deleteButton.setTitleColor(.systemBlue, for: .normal)

        addSubview(titleLabel)
        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            deleteButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with title: String, section: Int, delegate: SectionHeaderDelegate) {
        titleLabel.text = title
        self.section = section
        self.delegate = delegate
    }

    @objc private func deleteButtonTapped() {
        if let section = section {
            delegate?.deleteButtonTapped(in: section)
        }
    }
}

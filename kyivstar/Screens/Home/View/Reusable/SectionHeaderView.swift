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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .trailing
        button.setTitle("Del", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()

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

        addSubview(titleLabel)
        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with title: String, section: Int, delegate: SectionHeaderDelegate?) {
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

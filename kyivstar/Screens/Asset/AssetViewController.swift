//
//  AssetViewController.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import UIKit
import SnapKit

class AssetViewController: UIViewController {
    private var data: Asset
    private let contentView = AssetView()

    init(data: Asset) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
    }

    private func setupSubviews() {
        contentView.configure(with: data)
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

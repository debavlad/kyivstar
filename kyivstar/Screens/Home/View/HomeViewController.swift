//
//  HomeViewController.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()

    private let logoImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 104))
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Logo")
        return view
    }()

    private lazy var contentView = HomeView(provider: viewModel)

    override func loadView() {
        super.loadView()
        navigationItem.titleView = logoImageView
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupDataSource(for: contentView.collectionView)
        viewModel.fetchData()
    }
}

extension HomeViewController: SectionHeaderDelegate {
    func deleteButtonTapped(in section: Int) {
        // TODO: - Remove `Section`
    }
}

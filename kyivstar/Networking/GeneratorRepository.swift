//
//  GeneratorRepository.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation
import Moya
import RxSwift

protocol GeneratorRepositoryProtocol {
    // TODO: - Replace with `Observable`
    func getCategories(completion: @escaping (GetCategoriesResponse) -> Void)
}

class GeneratorRepository: GeneratorRepositoryProtocol {
    private let provider: MoyaProvider<GeneratorEndpoint>
    private let disposeBag = DisposeBag()

    init() {
        let authPlugin = AccessTokenPlugin { _ in
            "u0xj6pw0fdf7m2l1dvcic7uolk45e79itgin54l8"
        }
        provider = MoyaProvider<GeneratorEndpoint>(plugins: [authPlugin])
    }

    func getCategories(completion: @escaping (GetCategoriesResponse) -> Void) {
        provider.rx
            .request(.getCategories)
            .map(GetCategoriesResponse.self)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

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
    func getPromotions(completion: @escaping (GetPromotionsResponse) -> Void)
    func getCategories(completion: @escaping (GetCategoriesResponse) -> Void)
    func getContentGroups(completion: @escaping (GetContentGroupsResponse) -> Void)
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

    func getPromotions(completion: @escaping (GetPromotionsResponse) -> Void) {
        provider.rx
            .request(.getPromotions)
            .map(GetPromotionsResponse.self)
            .subscribe(onSuccess: completion)
            .disposed(by: disposeBag)
    }

    func getCategories(completion: @escaping (GetCategoriesResponse) -> Void) {
        provider.rx
            .request(.getCategories)
            .map(GetCategoriesResponse.self)
            .subscribe(onSuccess: completion)
            .disposed(by: disposeBag)
    }

    func getContentGroups(completion: @escaping (GetContentGroupsResponse) -> Void) {
        provider.rx
            .request(.getContentGroups)
            .map(GetContentGroupsResponse.self)
            .subscribe(onSuccess: completion)
            .disposed(by: disposeBag)
    }
}

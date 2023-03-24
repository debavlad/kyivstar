//
//  GeneratorRepository.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Foundation
import Alamofire

protocol AssetRepositoryProtocol: AnyObject {
    func getPromotions() async throws -> GetPromotionsResponse
    func getCategories() async throws -> GetCategoriesResponse
    func getContentGroups() async throws -> GetContentGroupsResponse
}

class AssetRepository: BaseRepository, AssetRepositoryProtocol {
    private let headers: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer u0xj6pw0fdf7m2l1dvcic7uolk45e79itgin54l8")
        return headers
    }()

    func getPromotions() async throws -> GetPromotionsResponse {
        let response: GetPromotionsResponse = try await request(
            endpoint: .getPromotions, headers: headers)
        return response
    }

    func getCategories() async throws -> GetCategoriesResponse {
        let response: GetCategoriesResponse = try await request(
            endpoint: .getCategories, headers: headers)
        return response
    }

    func getContentGroups() async throws -> GetContentGroupsResponse {
        let response: GetContentGroupsResponse = try await request(
            endpoint: .getContentGroups, headers: headers)
        return response
    }
}

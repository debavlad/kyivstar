//
//  BaseRepository.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 24.03.2023.
//

import Alamofire

protocol BaseRepositoryProtocol {
    func request<T: Decodable>(endpoint: Endpoint, headers: HTTPHeaders) async throws -> T
}

class BaseRepository {
    func request<T>(endpoint: Endpoint, headers: HTTPHeaders) async throws -> T where T : Decodable {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint.url, method: endpoint.method, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { responce in
                    if let value = responce.value {
                        continuation.resume(returning: value)
                    } else if let error = responce.error {
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

//
//  GeneratorEndpoint.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import Moya

enum GeneratorEndpoint {
    case getPromotions
    case getCategories
    case getContentGroups
    case getAssetDetails
}

extension GeneratorEndpoint: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        URL(string: "https://api.json-generator.com/templates")!
    }

    var path: String {
        switch self {
        case .getPromotions:
            return "/j_BRMrbcY-5W/data"
        case .getCategories:
            return "/eO-fawoGqaNB/data"
        case .getContentGroups:
            return "/PGgg02gplft-/data"
        case .getAssetDetails:
            return "/04Pl5AYhO6-n/data"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        .requestPlain
    }

    var headers: [String : String]? {
        nil
    }

    var authorizationType: AuthorizationType? {
        .bearer
    }
}

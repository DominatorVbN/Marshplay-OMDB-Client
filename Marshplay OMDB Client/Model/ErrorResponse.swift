//
//  ErrorResponse.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let response, error: String

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}

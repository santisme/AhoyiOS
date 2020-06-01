//
//  GetAPIKey.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 01/06/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var apiKey: String {
        return try! Configuration.value(for: "API_KEY")
    }
    
    static var apiAdminName: String {
        return try! Configuration.value(for: "API_ADMIN_NAME")
    }
}

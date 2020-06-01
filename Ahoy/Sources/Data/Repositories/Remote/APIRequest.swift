//
//  APIRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 18/07/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

let apiDomain="mdiscourse.keepcoding.io"
let apiProtocol="https"
let apiUrl = "\(apiProtocol)://\(apiDomain)"

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol APIRequest: Encodable {
    associatedtype Response: Codable
    var method: Method { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var body: [String: Any] { get }
    var headers: [String: String] { get }
}

// MARK: - Default implementation of the Protocol APIRequest
extension APIRequest {
    var baseUrl: URL {
        guard let baseUrl = URL(string: apiUrl) else {
            fatalError("URL not valid!")
        }
        return baseUrl
    }
    
    func requestWithBaseUrl() -> URLRequest {
        // Primero definimos cual va a ser el recurso a llamar
        let url = baseUrl.appendingPathComponent(path)
        
        // Definimos los componentes de la conexión
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Not able to create components")
        }
        
        // Añadimos los parámetros a la URL
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        // Creamos la URL final con los parámetros y componentes necesarios
        guard let finalUrl = components.url else {
            fatalError("Unable to retrieve finalUrl")
        }
        
        // Creamos la URLRequest
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        
        // Si el body existe, se añade a la request
        if !body.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        // Añadimos los Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Añadimos el API key a los Headers
        request.addValue(API.apiKey, forHTTPHeaderField: "Api-Key")
        // Aquí se indica el nombre de usuario con el que nos hemos registrado como usuario
        request.addValue(API.apiAdminName, forHTTPHeaderField: "Api-Username")
        
        return request
    }
}

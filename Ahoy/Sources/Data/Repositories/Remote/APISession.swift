//
//  APISession.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 18/07/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class APISession {
        
    lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
        return urlSession
    }()
    
    func send<T: APIRequest>(request: T, completion: @escaping (Result<T.Response, Error>) -> ()) {
        let request = request.requestWithBaseUrl()
        
        
        let task = session.dataTask(with: request) { data, response, error in
            //            print("data: \(String(describing: error))")
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(T.Response.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                }
                
            } catch let catchError {
                print("ERROR: Unexpected response: \(response ?? URLResponse())" )
                print("ERROR: No response for request \(request)")
                print("ERROR: Decoding JSON: \(catchError)")
            }
        }
        task.resume()
    }
    
    
    
    func send<T: APIRequestData>(request: T, completion: @escaping (Result<Data, Error>) -> ()) {
        let request = request.requestWithBaseUrl()
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
        task.resume()
    }
    
}

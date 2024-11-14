//
//  APIService.swift
//  StudLogs
//
//  Created by admin on 02/03/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
}

enum RequestError: String, Error {
    case invalidURL = "Invalid URL!"
    case noResponse = "No Response!"
    case decode = "Decode Error!"
    case unauthorized = "Unauthorized User!"
    case serverError = "Server Error!"
    case unexpectedStatusCode = "Unexpected Status Code!"
    case unknown = "Unknown Request Error!"
}

class APIService {
    
    static func sendRequest<T: Decodable>(endpoint: String, request: Data? = nil, responseModel: T.Type, httpMethod: HTTPMethod = .get, jsonBody: [String: Any]? = nil, complition: @escaping (Result<T, RequestError>)->()) {
        
        guard let url = URL(string: endpoint) else {
            complition(.failure(.invalidURL))
            return
        }
        print(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept") //Optional
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if httpMethod != .get {
            if let params = jsonBody {
                let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = jsonData
            }
        }
        
        if let request = request {
            urlRequest.httpBody = request
        }
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                complition(.failure(.noResponse))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                complition(.failure(.noResponse))
                return
            }
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedData: T = try JSONDecoder().decode(T.self, from: data)
                    complition(.success(decodedData))
                    return
                    
                } catch {
                    print(error)
                    complition(.failure(.decode))
                    return
                }
                
            case 401...418:
                complition(.failure(.unauthorized))
                return
                
            case 500...511:
                complition(.failure(.serverError))
                return
                
            default:
                complition(.failure(.unexpectedStatusCode))
                return
            }
        }.resume()
        
    }
}

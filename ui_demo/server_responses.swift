//
//  server_responses.swift
//  ui_demo
//
//  Created by Andrew Welling on 3/10/25.
//

import Foundation
// func to recieve a responses here
func retrieveFromServer() -> serverResponse {
    return serverResponse(status: "success", message: "Hello, World!")
}

// parse json files
func parseJSON<T: Decodable>(fromFile filename: String, type: T.Type) -> T? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("Failed to find \(filename).json")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Error parsing \(filename).json: \(error)")
        return nil
    }
}

struct serverResponse: Decodable {
    var status: String
    var message: String
}

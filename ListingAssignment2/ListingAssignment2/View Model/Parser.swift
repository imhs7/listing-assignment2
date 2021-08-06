//
//  Parser.swift
//  ListingAssignment2
//
//  Created by Hemant Sharma on 06/08/21.
//

import Foundation

public class Parser<D: Decodable> {
    
    private let session = URLSession.shared
    
    public func fetchData(from urlString: String, completion: @escaping (D) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let jsonData = try JSONDecoder().decode(D.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
}

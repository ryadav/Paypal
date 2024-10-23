//
//  APODService.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//

import Foundation

class APODService {
    private let apiKey = "YW0EFFEzDfWQgNafUJbwsH8gJPBfY5Ha71xKem5L"
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    func fetchPictures(startDate: String, endDate: String, completion: @escaping ([APODModel]?) -> Void) {
        let urlString = "\(baseURL)?api_key=\(apiKey)&start_date=\(startDate)&end_date=\(endDate)"
        print("start date \(startDate) and end date is ==== \(endDate)")
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let pictures = try decoder.decode([APODModel].self, from: data)
                print(pictures)
                completion(pictures)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

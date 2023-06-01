//
//  QuotesViewModel.swift
//  SageSay
//
//  Created by Eldar Tutnjic on 1. 6. 2023..
//

import Foundation

class QuotesViewModel {
    func fetchQuotes(completion: @escaping ([Quotes]) -> Void) {
        let urlString = "https://type.fit/api/quotes"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let quotes = try JSONDecoder().decode([Quotes].self, from: data)
                completion(quotes)
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}

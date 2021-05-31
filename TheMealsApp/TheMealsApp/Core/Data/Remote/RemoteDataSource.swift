//
//  RemoteRepository.swift
//  MealsApps
//
//  Created by Gilang Ramadhan on 11/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

import Alamofire
import Combine


protocol RemoteDataSourceProtocol: class {

 // func getCategories(result: @escaping (Result<[CategoryResponse], URLError>) -> Void)
    
    func getCategories() -> AnyPublisher<[CategoryResponse], Error>
  
}

final class RemoteDataSource: NSObject {



  static let sharedInstance: RemoteDataSource =  RemoteDataSource()

}

extension RemoteDataSource: RemoteDataSourceProtocol {

    /*
  func getCategories(
    result: @escaping (Result<[CategoryResponse], URLError>) -> Void
  ) {
    guard let url = URL(string: Endpoints.Gets.categories.url) else { return }

    let task = URLSession.shared.dataTask(with: url) { maybeData, maybeResponse, maybeError in
      if maybeError != nil {
        result(.failure(.addressUnreachable(url)))
      } else if let data = maybeData, let response = maybeResponse as? HTTPURLResponse, response.statusCode == 200 {
        let decoder = JSONDecoder()
        do {
          let categories = try decoder.decode(CategoriesResponse.self, from: data).categories
          result(.success(categories))
        } catch {
          result(.failure(.invalidResponse))
        }
      }
    }
    task.resume()

  }
 
 */
 /*
    func getCategories(
        result: @escaping (Result<[CategoryResponse], URLError>) -> Void
    ) {
        guard let url = URL(string: Endpoints.Gets.categories.url) else {
            return
        }
        
        AF.request(url).validate().responseDecodable(of: CategoriesResponse.self) { (response) in
            switch response.result {
            case .success(let value):
                result(.success(value.categories))
            
            case .failure:
                result(.failure(.invalidResponse))
            }
        }
    }
 
 */
    
    func getCategories() -> AnyPublisher<[CategoryResponse], Error> {
       return Future<[CategoryResponse], Error> { completion in
         if let url = URL(string: Endpoints.Gets.categories.url) {
           AF.request(url)
             .validate()
             .responseDecodable(of: CategoriesResponse.self) { response in
               switch response.result {
               case .success(let value):
                 completion(.success(value.categories))
               case .failure:
                 completion(.failure(URLError.invalidResponse))
               }
             }
         }
       }.eraseToAnyPublisher()
    }

}

//
//  MealsRepository.swift
//  MealsApps
//
//  Created by Gilang Ramadhan on 11/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

protocol MealRepositoryProtocol {

  func getCategories(result: @escaping (Result<[CategoryModel], Error>) -> Void)

}

final class MealRepository: NSObject {

  typealias MealInstance = (LocaleDataSource, RemoteDataSource) -> MealRepository

  fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource

    private init(locale: LocaleDataSource,remote: RemoteDataSource) {
    self.remote = remote
        self.locale = locale
  }

  static let sharedInstance: MealInstance = { localeRepo,remoteRepo in
    return MealRepository(locale: localeRepo, remote: remoteRepo)
  }

}

extension MealRepository: MealRepositoryProtocol {
    func getCategories(result: @escaping (Result<[CategoryModel], Error>) -> Void) {
        locale.getCategories { (localeResponse) in
            switch localeResponse {
            case.success(let categoryEntity):
                let categoryList = CategoryMapper.mapCategoryEntitiesToDomains(input: categoryEntity)
                
                if categoryList.isEmpty {
                    self.remote.getCategories { (remoteResponse) in
                        switch remoteResponse {
                            
                        case .success(let categoryReponse):
                            let categoryEntities = CategoryMapper.mapCategoryResponsesToEntities(input:categoryReponse)
                            
                        
                            self.locale.addCategories(from: categoryEntities) { (addState) in
                                switch addState {
                                
                                case .success(let resultFromAdd):
                                    if resultFromAdd {
                                        self.locale.getCategories { (localeResponses) in
                                            switch localeResponse {
                                            
                                            case .success(let categoryEntity):
                                                let resultList = CategoryMapper.mapCategoryEntitiesToDomains(input: categoryEntity)
                                                
                                                result(.success(resultList))
                                            case .failure(_):
                                                print("FUCK")
                                            }
                                        }
                                    }
                                case .failure(_):
                                    print("FUCK")
                                }
                            }
                        case .failure(_):
                            print("FUCK")
                        }
                    }
                } else {
                    result(.success(categoryList))
                }
                
                
              
            case .failure(_):
                print("FUCK YOU")
            }
    }
    

    /*
  func getCategories(
    result: @escaping (Result<[CategoryModel], Error>) -> Void
  ) {

    self.remote.getCategories { remoteResponses in
      switch remoteResponses {
      case .success(let categoryResponses):
        let resultList = CategoryMapper.mapCategoryResponsesToDomains(input: categoryResponses)
        result(.success(resultList))
      case .failure(let error):
        result(.failure(error))
      }
    }
  } */
    
    
    
}
}

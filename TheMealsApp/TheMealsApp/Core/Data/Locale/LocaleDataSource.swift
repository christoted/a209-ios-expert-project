//
//  LocaleDataSource.swift
//  TheMealsApp
//
//  Created by Christopher Teddy  on 12/05/21.
//

import Foundation
import RealmSwift
import Combine


protocol LocaleDataSourceProtocol: class {
//    func getCategories(result: @escaping (Result<[CategoryEntity], DatabaseError>) -> Void)
//
//    func addCategories(
//        from categories: [CategoryEntity],
//        result: @escaping (Result<Bool, DatabaseError>) -> Void
//    )
    
    func getCategories() -> AnyPublisher<[CategoryEntity], Error>
    func addCategories(from categories: [CategoryEntity]) -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource: NSObject {
    
    private let realm: Realm?
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> LocaleDataSource = {
        realmDatabse in return LocaleDataSource(realm: realmDatabse)
    }
 
}


extension LocaleDataSource: LocaleDataSourceProtocol {
    
    /*
    func getCategories(result: @escaping (Result<[CategoryEntity], DatabaseError>) -> Void) {
        if let realm = realm {
            let categories: Results<CategoryEntity> = {
                realm.objects(CategoryEntity.self)
                    .sorted(byKeyPath: "title", ascending: true)
            }()
            
            result(.success(categories.toArray(ofType: CategoryEntity.self)))
        } else {
            result(.failure(.invalidInstance))
        }
    }
    
    func addCategories(from categories: [CategoryEntity], result: @escaping (Result<Bool, DatabaseError>) -> Void) {
        if let realm = realm {
            do {
                try realm.write{
                    for category in categories {
                        realm.add(category, update: .all)
                    }
                    result(.success(true))
                }
               
            } catch {
                result(.failure(.requestFailed))
            }
        } else {
            result(.failure(.invalidInstance))
        }
    
    } */
    
//    func getCategories() -> AnyPublisher<[CategoryEntity], Error> {
//        return Future<[CategoryEntity], Error> { completion in
//          if let realm = self.realm {
//            let categories: Results<CategoryEntity> = {
//              realm.objects(CategoryEntity.self)
//                .sorted(byKeyPath: "title", ascending: true)
//            }()
//            completion(.success(categories.toArray(ofType: CategoryEntity.self)))
//          } else {
//            completion(.failure(DatabaseError.invalidInstance))
//          }
//        }.eraseToAnyPublisher()
//      }
    
    func getCategories() -> AnyPublisher<[CategoryEntity], Error> {
        return Future<[CategoryEntity], Error> { completion in
            if let realm = self.realm {
                let categories: Results<CategoryEntity> = {
                    realm.objects(CategoryEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                }()
                completion(.success(categories.toArray(ofType: CategoryEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
        
    }
    
    func addCategories(from categories: [CategoryEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write{
                        for category in categories {
                            realm.add(category, update: .all)
                        }
                        
                        completion(.success(true))
                    }
                
                } catch  {
                    completion(.failure(DatabaseError.requestFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
    

}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

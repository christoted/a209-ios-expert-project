//
//  CategoryEntity.swift
//  TheMealsApp
//
//  Created by Christopher Teddy  on 12/05/21.
//

import Foundation
import RealmSwift

//Realm NoSQL

class CategoryEntity: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var desc: String = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

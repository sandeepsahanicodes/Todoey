//
//  Item.swift
//  Todoey
//
//  Created by Sandeep Sahani on 11/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Reverse relationship that means each item will point to a category. This is many to one relationship meaning many items can belong to same category.
}

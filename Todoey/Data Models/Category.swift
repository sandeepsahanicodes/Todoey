//
//  Category.swift
//  Todoey
//
//  Created by Sandeep Sahani on 11/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    var items = List<Item>() // Forward relationship that means each category will have list of items. This is one too many relationship meaning one category will contain many items.
}

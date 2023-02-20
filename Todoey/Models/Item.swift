//
//  Item.swift
//  Todoey
//
//  Created by Sandeep Sahani on 19/02/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

/// Model for an item in table view cell.
class Item: Codable
{
    var title: String = ""
    var done: Bool = false
}

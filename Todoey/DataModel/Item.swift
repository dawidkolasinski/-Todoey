//
//  Item.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 02/09/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //items - forward relationship
    
}


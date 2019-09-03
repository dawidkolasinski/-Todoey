//
//  Category.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 02/09/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //relationship
    let items = List<Item>()   //List of Item objects, forward relationship
    
}




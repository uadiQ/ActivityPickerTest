//
//  ActivityItem.swift
//  ActivityPickerTest
//
//  Created by swstation on 10/30/18.
//  Copyright © 2018 SoftwareStation. All rights reserved.
//

import Foundation

class Activity {
    let name: String
    let id: String
    let sortingPriority: Int
    var children: [Activity]
    let isRoot: Bool
    
    init(name: String,
         id: String,
         sortPrio: Int,
         children: [Activity] = [],
         isRoot: Bool = true) {
        
        self.name = name
        self.id = id
        self.sortingPriority = sortPrio
        self.children = children
        self.isRoot = isRoot
        
    }
    
    func addChild(_ child: Activity) {
        self.children.append(child)
    }
}

//
//  PickerViewmodel.swift
//  ActivityPickerTest
//
//  Created by swstation on 10/30/18.
//  Copyright © 2018 SoftwareStation. All rights reserved.
//

import Foundation

protocol PickerViewModel: class {
    
}

protocol ActivityPickerViewModelType: PickerViewModel {
    func numberOfItemsInSection(_ section: Int) -> Int
}

class ActivityPickerViewModel: ActivityPickerViewModelType {
    
    var selectedActivity: Activity?
    var isSubselecting: Bool = false
    var rootActivities = [Activity]() //should be fetched onced at viewModel creation
    var currentActivities: [Activity] { // to store activities that shoud be displayed ATM
        if self.isSubselecting {
            guard let activity = selectedActivity else {
                return []
            }
            return childrenOf(activity: activity)
        } else {
            return rootActivities
        }
    }
    
    init() {
        fetchRootActivities()
    }
    
    private func generateMockup() -> [Activity] {
        let ten = Activity(name: "0 - 10", id: "ten", sortPrio: 0)
        let twenty = Activity(name: "11 - 20", id: "twenty", sortPrio: 1)
        let thirty = Activity(name: "21 - 30", id: "thirty", sortPrio: 2)
        let fourty = Activity(name: "31 - 40", id: "fourty", sortPrio: 3)
        
        let eleven = Activity(name: "11", id: "eleven", sortPrio: 0, isRoot: false)
        let twelve = Activity(name: "12", id: "twelve", sortPrio: 1, isRoot: false)
        ten.addChild(eleven)
        ten.addChild(twelve)
        
        return [ten, twenty, thirty, fourty, eleven, twelve]
    }
    
    private func fetchRootActivities() {
        let allActivities = generateMockup()
        for item in allActivities {
            if item.isRoot {
                rootActivities.append(item)
            }
        }
    }

    private func childrenOf(activity: Activity) -> [Activity] {
        return activity.children
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        let additionalCells = isSubselecting ? 2 : 1 // for root one and "add"
        return currentActivities.count + additionalCells
    }
}

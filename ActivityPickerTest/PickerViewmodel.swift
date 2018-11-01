//
//  PickerViewmodel.swift
//  ActivityPickerTest
//
//  Created by swstation on 10/30/18.
//  Copyright © 2018 SoftwareStation. All rights reserved.
//

import UIKit

protocol PickerViewModel: class {
    
}

protocol ActivityPickerViewModelType: PickerViewModel {
    func numberOfItemsInSection(_ section: Int) -> Int
    func setupCell(_ cell: ActivityCollectionViewCell, indexPath: IndexPath)
    func processSelection(at indexPath: IndexPath)
    var dataSourceUpdated: (() -> Void)? { get set }
    var rollBackTo: ((IndexPath) -> Void)? { get set }
    var activitySelected: ((Activity?) -> Void)? { get set }
    var addPressed: (() -> Void)? { get set }
}

enum IndexPathType {
    case door
    case add
    case regular
}

class ActivityPickerViewModel: ActivityPickerViewModelType {
    
    var rollBackTo: ((IndexPath) -> Void)?
    var dataSourceUpdated: (() -> Void)?
    var activitySelected: ((Activity?) -> Void)?
    var addPressed: (() -> Void)?
    
    var selectedRootActivity: Activity?
    var currentlySelectedActivity: Activity?
    var isSubselecting: Bool = false
    var rootActivities = [Activity]() //should be fetched onced at viewModel creation
    var currentActivities: [Activity] {
        get {// to store activities that shoud be displayed ATM
            if self.isSubselecting {
                guard let activity = selectedRootActivity else {
                    return []
                }
                return childrenOf(activity: activity)
            } else {
                return rootActivities
            }
        }
        set {
            dataSourceUpdated?()
        }
    }
    
    init() {
        fetchRootActivities()
    }
    
    // only for current testcase
    private func generateMockup() -> [Activity] {
        let ten = Activity(name: "0 - 10", id: "ten", sortPrio: 0)
        let twenty = Activity(name: "11 - 20", id: "twenty", sortPrio: 1)
        let thirty = Activity(name: "21 - 30", id: "thirty", sortPrio: 2)
        let fourty = Activity(name: "31 - 40", id: "fourty", sortPrio: 3)
        let fifty = Activity(name: "41 - 50", id: "fifty", sortPrio: 3)
        let sixty = Activity(name: "51 - 60", id: "sixty", sortPrio: 3)
        
        let eleven = Activity(name: "11", id: "eleven", sortPrio: 0, isRoot: false)
        let twelve = Activity(name: "12", id: "twelve", sortPrio: 1, isRoot: false)
        let thirtyfour = Activity(name: "34", id: "thirtyfour", sortPrio: 1, isRoot: false)
        fourty.addChild(thirtyfour)
        ten.addChild(eleven)
        ten.addChild(twelve)
        
        return [ten, twenty, thirty, fourty, fifty, sixty, eleven, twelve]
    }
    
    // MARK: - Activities fetching(root and children)
    private func fetchRootActivities() {
        let allActivities = generateMockup()
        for item in allActivities {
            if item.isRoot {
                rootActivities.append(item)
            }
        }
        rootActivities.sort { $0.sortingPriority < $1.sortingPriority }
    }
    
    private func childrenOf(activity: Activity) -> [Activity] {
        return activity.children.sorted(by: { $0.sortingPriority < $1.sortingPriority })
    }
    
    //MARK: - Mediator called methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        let additionalCells = isSubselecting ? 2 : 1 // for root one and "add"
        return currentActivities.count + additionalCells
    }
    
    func setupCell(_ cell: ActivityCollectionViewCell, indexPath: IndexPath) {
        if isSubselecting {
            setupSubselectionCell(cell, indexPath: indexPath)
        } else {
            setupRootCell(cell, indexPath: indexPath)
        }
    }
    
    func processSelection(at indexPath: IndexPath) {
        if isSubselecting {
            processSubselectingClick(at: indexPath)
        } else {
            processUpperLevelClick(at: indexPath)
        }
    }
    
    // MARK: - Private methods for collectionView support
    private func indexPathType(with indexPath: IndexPath) -> IndexPathType {
        if isSubselecting {
            switch indexPath.item {
            case 0:
                return IndexPathType.door
            case numberOfItemsInSection(indexPath.section) - 1:
                return IndexPathType.add
            default:
                return IndexPathType.regular
            }
        } else {
            switch indexPath.item {
            case 0:
                return IndexPathType.add
            default:
                return IndexPathType.regular
            }
        }
    }
    
    private func popToUpperLevel() {
        guard let selectedActivity = selectedRootActivity else {
            debugPrint("App can't be in subselect without root activity")
            return
        }
        let arrayIndex = rootActivities.firstIndex { activity -> Bool in
            selectedActivity.id == activity.id
        }
        guard let neededIndex = arrayIndex else {
            debugPrint("No such activity in root activities")
            return
        }
        let popUpIndex = neededIndex + 1
        let popUpIndexPath = IndexPath(item: popUpIndex, section: 0)
        currentlySelectedActivity = nil
        isSubselecting = false
        activitySelected?(nil)
        rollBackTo?(popUpIndexPath)
    }
    
    private func addClicked() {
        print("going to add screen")
        addPressed?()
    }
    
    private func setupSubselectionCell(_ cell: ActivityCollectionViewCell, indexPath: IndexPath) {
        let cellType = indexPathType(with: indexPath)
        var cellText = ""
        
        guard let activity = selectedRootActivity else {
            debugPrint("No root activity")
            return
        }
        
        switch cellType {
        case .door:
            print("setting up door cell")
            cellText = activity.name
            cell.setState(ActivityCellState.door)
            
        case .add:
            print("setting up add cell")
            cellText = "Add"
            
            
        case .regular:
            print("setting up regular cell")
            let adjustedActivityIndex = indexPath.item - 1
            let activityChildren = childrenOf(activity: activity)
            
            guard adjustedActivityIndex >= 0 && adjustedActivityIndex < activityChildren.count else {
                debugPrint("Index is out of array boundaries")
                return
            }
            
            let itemForCell = activityChildren[adjustedActivityIndex]
            cellText = itemForCell.name
        }
        
        cell.setup(text: cellText)
    }
    
    private func setupRootCell(_ cell: ActivityCollectionViewCell, indexPath: IndexPath) {
        let cellType = indexPathType(with: indexPath)
        var cellText = ""
        
        switch cellType {
        case .add:
            print("setting up add cell")
            cellText = "Add"
            
        case .regular:
            print("setting up regular cell")
            let adjustedActivityIndex = indexPath.item - 1
            
            guard adjustedActivityIndex >= 0 && adjustedActivityIndex < rootActivities.count else {
                debugPrint("Index is out of array boundaries")
                return
            }
            let cellActivity = rootActivities[adjustedActivityIndex]
            cellText = cellActivity.name
            
        case .door:
            fatalError("wrong type of cell for level")
        }
        
        cell.setup(text: cellText)
    }
    
    private func processSubselectingClick(at indexPath: IndexPath) {
        guard indexPath.item != 0 else { // door clicked, going back to upper level
            popToUpperLevel()
            return
        }
        
        guard indexPath.item != currentActivities.count + 1 else { // add clicked, process
            addClicked()
            return
        }
        
        let adjustedItemIndex = indexPath.item - 1
        currentlySelectedActivity = currentActivities[adjustedItemIndex]
        activitySelected?(currentlySelectedActivity)
    }
    
    private func processUpperLevelClick(at indexPath: IndexPath) {
        guard indexPath.item != 0 else { // add clicked, process
            addClicked()
            return
        }
        let adjustedItemIndex = indexPath.item - 1
        let itemForIndex = rootActivities[adjustedItemIndex]
        currentlySelectedActivity = itemForIndex
        activitySelected?(currentlySelectedActivity)
        let itemChildActivites = childrenOf(activity: itemForIndex)
        
        guard !itemChildActivites.isEmpty else {
            print("no child items to display - default selection")
            return
        }
        
        selectedRootActivity = itemForIndex
        isSubselecting = true
        currentActivities = itemChildActivites
    }
}

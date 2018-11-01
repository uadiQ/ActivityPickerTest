//
//  PickerMediator.swift
//  ActivityPickerTest
//
//  Created by swstation on 10/30/18.
//  Copyright © 2018 SoftwareStation. All rights reserved.
//

import UIKit

protocol PickerMediator: class {
    
}

protocol ActivityPickerMediatorType: PickerMediator {
    
}

class ActivityPickerMediator: NSObject, ActivityPickerMediatorType {
    
    let viewModel: ActivityPickerViewModelType
    let collectionView: UICollectionView
    var selectedIndex: IndexPath?
    
    init(viewModel: ActivityPickerViewModelType, collection: UICollectionView) {
        self.viewModel = viewModel
        self.collectionView = collection
    }
    
    func setupViewModelBlocks() {
        viewModel.dataSourceUpdated = { [weak self] in
            self?.selectedIndex = nil
        }
    }
}

extension ActivityPickerMediator: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ActivityCollectionViewCell else {
            fatalError("wrong cell id")
        }
        
        viewModel.setupCell(cell, indexPath: indexPath)
        return cell
    }
    
}

extension ActivityPickerMediator: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //processing visual part of cell selection
        guard let cell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionViewCell else {
            return
        }
        
        if let currentSelection = selectedIndex,
            currentSelection == indexPath {
            
            selectedIndex = nil
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.setState(ActivityCellState.none)
            
        } else {
            if let prevSelection = selectedIndex,
                let prevCell = collectionView.cellForItem(at: prevSelection) as? ActivityCollectionViewCell {
                prevCell.setState(ActivityCellState.none)
            }
            
            selectedIndex = indexPath
            cell.setState(ActivityCellState.selected)
            
        }
        
        //calling viewmodel to do selection logic
        viewModel.processSelection(at: indexPath)
    }
    
    
}

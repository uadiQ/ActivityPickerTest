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
    var viewModel: ActivityPickerViewModelType
    let collectionView: UICollectionView
    
    init(viewModel: ActivityPickerViewModelType, collection: UICollectionView) {
        self.viewModel = viewModel
        self.collectionView = collection
    }
}

extension ActivityPickerMediator: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseID, for: indexPath) as? ActivityCollectionViewCell else {
            fatalError("wrong cell id")
        }
        
        viewModel.setupCell(cell, indexPath: indexPath)
        return cell
    }
    
}

extension ActivityPickerMediator: UICollectionViewDelegate {
    
}

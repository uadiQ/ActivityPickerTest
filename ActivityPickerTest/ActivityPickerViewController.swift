//
//  ActivityPickerViewController.swift
//  ActivityPickerTest
//
//  Created by swstation on 10/30/18.
//  Copyright © 2018 SoftwareStation. All rights reserved.
//

import UIKit

class ActivityPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ActivityPickerViewModelType!
    var mediator: ActivityPickerMediator!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ActivityPickerViewModel()
        mediator = ActivityPickerMediator(viewModel: viewModel,
                                          collection: collectionView)
        
        collectionView.dataSource = mediator
        collectionView.delegate = mediator
        collectionView.register(ActivityCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseID)
    }
    
    
}

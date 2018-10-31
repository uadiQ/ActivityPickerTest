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
        setupViewModelBlocks()
    }
    
    private func setupViewModelBlocks() {
        viewModel.dataSourceUpdated = {[weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.rollBackTo = { [weak self] indexPath in
            self?.collectionView.scrollToItem(at: indexPath,
                                              at: .centeredHorizontally,
                                              animated: true)
        }
    }
    
}

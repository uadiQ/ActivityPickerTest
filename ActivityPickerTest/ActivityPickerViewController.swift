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
    @IBOutlet weak var selectedActivityLabel: UILabel!
    
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
        mediator.setupViewModelBlocks()
    }
    
    private func setupViewModelBlocks() {
        
        viewModel.rollBackTo = { [weak self] indexPath in
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: indexPath,
                                              at: .centeredHorizontally,
                                              animated: true)
        }
        
        viewModel.activitySelected = { [weak self] optionalActivity in
            guard let `self` = self else { return }
            
            guard let activity = optionalActivity else {
                self.selectedActivityLabel.text = "No activity selected"
                return
            }
            
            self.selectedActivityLabel.text = activity.name
        }
        
        viewModel.addPressed = { [weak self] in
            self?.showAddAlert()
        }
    }
    
    private func showAddAlert() {
        let alert = UIAlertController(title: "Add pressed", message: "Add more activities dialog should be shown", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}

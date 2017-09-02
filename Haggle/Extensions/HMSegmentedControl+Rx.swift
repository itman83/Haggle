//
//  HMSegmentedControl+Rx.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/3/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//


import UIKit
import HMSegmentedControl
import RxSwift
import RxCocoa


/// Custom Reactive extension for HMSegmentedControl
/// Get current index of segment. 

// reactive code accessible through rx namespace.
extension Reactive where Base: HMSegmentedControl {

    var selectedIndex: Observable<Int> {
        return self.base.rx.controlEvent(.valueChanged)
            .map { self.base.selectedSegmentIndex }
    }
}



extension HMSegmentedControl {
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        // Can keep code in prepare method, or add it here, with the exception of titles.

    }
    
    
    /// IN MVVM, these modifications could rightfully go in viewModel, but since I would have to execute this code in multiple viewmodels, leave it here to avoid duplicate code in two separate view models. Only change is the titles.
    func prepareUI(titles: [String]) {

        self.sectionTitles = titles
        // Set initial index to 0 to prevent initial blank collectionView
        self.selectedSegmentIndex = 0
        self.selectionIndicatorHeight = 2
        self.backgroundColor = .white
        let purple = UIColor(colorLiteralRed: 71/255, green: 81/255, blue: 243/255, alpha: 1)
        self.selectionIndicatorColor = purple
        self.selectionIndicatorLocation = .down
        self.selectedTitleTextAttributes = [NSForegroundColorAttributeName: purple,
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold",
                                                                        size: 11)! ]
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray,
                                    NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold",
                                                                size: 11)! ]

    }
}


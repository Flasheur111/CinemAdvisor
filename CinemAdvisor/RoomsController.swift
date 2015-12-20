//
//  RoomsController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class RoomsController: UIViewController {
    var detailCinema: Cinema? {
        didSet {
            configureView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    func configureView() {
        print(detailCinema?.adresse)
    }
}


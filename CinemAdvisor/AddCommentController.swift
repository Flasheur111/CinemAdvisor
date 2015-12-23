//
//  AddCommentController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 22/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit
class AddCommentController: UIViewController, FloatRatingViewDelegate {
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var liveRate: UILabel!
    
    @IBOutlet var addAction: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatRatingView.delegate = self
        self.liveRate.text = NSString(format:"%.2f" , self.floatRatingView.rating) as String
    }

    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        self.liveRate.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        self.liveRate.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

}
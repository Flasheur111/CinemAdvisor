//
//  CommentsController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CommentsController: UIViewController, FloatRatingViewDelegate {
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        //self.floatRatingView.fullImage = UIImage(named: "StarFull")
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    
}

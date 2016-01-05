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
    @IBOutlet var cinema: UITextField!
    @IBOutlet var room: UITextField!
    
    @IBOutlet var comment: UITextField!
    @IBOutlet var user: UITextField!
    
    var cinemaModel:Cinema? = nil;
    var roomModel:Room? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatRatingView.delegate = self
        self.liveRate.text = NSString(format:"%.2f" , self.floatRatingView.rating) as String
        self.cinema.text = cinemaModel!.name;
        self.room.text = roomModel!.name;
    }
    
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        self.liveRate.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        self.liveRate.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "unwindToSegue" {
                if (self.user.text == "")
                {
                    ErrorAlert.FieldsNotFilled(self)
                    return false
                }
                else {
                    return true
                }
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender!.tag == 2)
        {
            DataManager.AddComment(
                (self.cinemaModel?.id)!,
                roomId: (self.roomModel?.roomId)!,
                comment: self.comment.text!,
                user: self.user.text!,
                rate: String(self.floatRatingView.rating),
                completion: (segue.destinationViewController as! CommentsController).refreshComment)
        }
        
    }
    
    
}
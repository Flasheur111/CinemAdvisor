//
//  CommentsController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CommentsController: UITableViewController {
    var comments: Array<Comment> = Array<Comment>()
    var cinema: Cinema? = nil
    
    var room: Room? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.GetCommentsByCinemaRoomId((self.cinema?.id)!, roomId: (self.room?.roomId)!, completion: setComments)
    }
    
    func setComments(comments:Array<Comment>) -> Void {
        self.comments = comments;
        
        dispatch_async(dispatch_get_main_queue(), {
           self.tableView.reloadData()
        });
    }
    
    
        @IBAction func unwindToSegue (segue: UIStoryboardSegue) {
            let source: AddCommentController = segue.sourceViewController as! AddCommentController
            DataManager.AddComment(
                (self.cinema?.id)!,
                roomId: (self.room?.roomId)!,
                comment: source.comment.text!,
                user: source.user.text!,
                rate: String(source.floatRatingView.rating))
        }
       /*
        func appendRoom(room: Room?) -> Void {
            dispatch_async(dispatch_get_main_queue(), {
                if (room != nil) {
                    self.rooms.append(room!)
                    self.tableView.reloadData()
                }
                else {
                    let alertController = UIAlertController(title: "Erreur", message: "Cette salle existe déjà !", preferredStyle: .Alert)
                    let yesAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in})
                    alertController.addAction(yesAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            });
        }*/
        
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1;
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.comments.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CommentCellController
            
            let comment: Comment = self.comments[indexPath.row]
            cell.userLabel.text = comment.user
            cell.commentLabel.text = comment.comment
            cell.floatRatingView.rating = comment.star
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            cell.dateLabel.text = dateFormatter.stringFromDate(comment.date)
            
            return cell;
        }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (self.cinema != nil && self.room != nil) {
            let secondViewController = segue.destinationViewController as! AddCommentController
            secondViewController.cinemaModel = (self.cinema)!
            secondViewController.roomModel = (self.room)!
        }
    }
    
    
}

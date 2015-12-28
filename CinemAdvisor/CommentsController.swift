//
//  CommentsController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    var comments: Array<Comment> = Array<Comment>()
    var cinema: Cinema? = nil
    
    var room: Room? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshComment(nil);
    }
    
    func setComments(comments:Array<Comment>) -> Void {
        self.comments = comments;
        
        dispatch_async(dispatch_get_main_queue(), {
            if self.comments.count <= 0 {
                let noDataLabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
                noDataLabel.numberOfLines = 3
                noDataLabel.text             = "Il n'y pas encore de note ajoutée.\n\nSoit le premier à en ajouter une !"
                noDataLabel.textColor        = UIColor.blackColor()
                noDataLabel.textAlignment = NSTextAlignment.Center
                self.tableView.backgroundView = noDataLabel
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            }
            else
            {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.reloadData()
            }
        });
    }
    
    func refreshComment(error: String?) {
        if (error != nil) {
            ErrorAlert.CannotAddComment(self, error: error!)
        }
        else {
            DataManager.GetCommentsByCinemaRoomId((self.cinema?.id)!, roomId: (self.room?.roomId)!, completion: setComments)
        }
    }
    
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
        return 90;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender!.tag == 2)
        {
            if (self.cinema != nil && self.room != nil) {
                let secondViewController = segue.destinationViewController as! AddCommentController
                secondViewController.cinemaModel = (self.cinema)!
                secondViewController.roomModel = (self.room)!
            }
        }
    }
    
    @IBAction func unwindToSegue (segue: UIStoryboardSegue) {
        refreshComment(nil)
    }
}

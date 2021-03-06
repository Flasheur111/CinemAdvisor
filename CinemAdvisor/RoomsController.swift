//
//  RoomsController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class RoomsController: UITableViewController {
    var rooms: Array<Room> = Array<Room>()
    var cinema: Cinema? = nil
    @IBOutlet var cinemaName: String?
    
    var detailCinema: Cinema? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let titleCinema = detailCinema {
            self.title = "Salles : \(titleCinema.name.capitalizedString)"
        }
        let tlabel = UILabel(frame: (CGRectMake(0, 0, 200,40)))
        tlabel.text=self.navigationItem.title;
        tlabel.textColor = UIColor.whiteColor()
        tlabel.font = UIFont(name: "Helvetica-Bold", size:  15.0)
        tlabel.backgroundColor = UIColor.clearColor()
        tlabel.adjustsFontSizeToFitWidth=true;
        self.navigationItem.titleView=tlabel;
        self.navigationItem.titleView?.center
        self.refreshRoom(nil)
    }
    
    func setRooms(error: String?, rooms: Array<Room>?) -> Void {
        if (error != nil) {
            ErrorAlert.CannotConnect(self);
        }
        else
        {
            self.rooms = rooms!
            dispatch_async(dispatch_get_main_queue(), {
                if self.rooms.count <= 0 {
                    let noDataLabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
                    noDataLabel.numberOfLines = 3
                    noDataLabel.text             = "Il n'y pas encore de salle ajoutée.\n\nSoit le premier à en ajouter une !"
                    noDataLabel.textColor        = UIColor.blackColor()
                    noDataLabel.textAlignment = NSTextAlignment.Center
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                    self.tableView.backgroundView = noDataLabel
                }
                else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    self.tableView.reloadData()
                }
            });
        }
    }
    
    func configureView() {
        self.cinema = detailCinema!
    }
    
    @IBAction func unwindToSegue (segue: UIStoryboardSegue) {
        refreshRoom(nil);
    }
    
    func refreshRoom(error: String?) -> Void {
        if (error != nil) {
            ErrorAlert.CannotAddRoom(self, error: error!);
        } else {
            DataManager.GetRoomsByCinemaId((self.detailCinema?.id)!, completion: setRooms)
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RoomCellController
        
        let room: Room = self.rooms[indexPath.row]
        cell.roomLabel.text = room.name
        cell.floatRatingView.rating = room.grade
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let secondViewController = segue.destinationViewController as! CommentsController
            secondViewController.cinema = self.cinema;
            secondViewController.room = self.rooms[indexPath.row];
        }
    }
    
}


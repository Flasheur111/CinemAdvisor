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
        tlabel.font = UIFont(name: "Helvetica-Bold", size:  30.0)
        tlabel.backgroundColor = UIColor.clearColor()
        tlabel.adjustsFontSizeToFitWidth=true;
        self.navigationItem.titleView=tlabel;
        DataManager.GetRoomsByCinemaId((self.detailCinema?.id)!, completion: setRooms)
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
                    self.tableView.reloadData()
                }
            });
        }
    }
    
    func configureView() {
        self.cinema = detailCinema!
    }
    
    @IBAction func unwindToSegue (segue: UIStoryboardSegue) {
        let source: AddRoomController = segue.sourceViewController as! AddRoomController
        DataManager.AddRoom(self.cinema!.id, roomName: source.roomName, completion: appendRoom)
    }
    
    func appendRoom(room: Room?) -> Void {
        dispatch_async(dispatch_get_main_queue(), {
            if (room != nil) {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
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


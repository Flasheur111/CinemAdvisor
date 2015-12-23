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
    var manager: DataManager = DataManager()
    var cinema: Cinema? = nil
    
    var detailCinema: Cinema? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.GetRoomsByCinemaId((self.detailCinema?.id)!, completion: setRooms)
    }
    
    func setRooms(rooms: Array<Room>) -> Void {
        self.rooms = rooms
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        });
    }
    
    func configureView() {
        print(detailCinema?.adresse)
        self.cinema = detailCinema!
    }
    
    @IBAction func unwindToSegue (segue: UIStoryboardSegue) {
        let source: AddRoomController = segue.sourceViewController as! AddRoomController
        self.manager.AddRoom(self.cinema!.id, roomName: source.roomName, completion: appendRoom)
    }

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
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")

        let room: Room = self.rooms[indexPath.row]
        cell!.textLabel?.text = room.name
        
        return cell!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let secondViewController = segue.destinationViewController as! CommentsController
            secondViewController.cinema = self.cinema;
            secondViewController.room = self.rooms[indexPath.row];
        }
    }
    
}


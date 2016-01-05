//
//  AddController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class AddRoomController: UIViewController {
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender!.tag == 2){
            let source: RoomsController = segue.destinationViewController as! RoomsController
            DataManager.AddRoom(source.cinema!.id, roomName: roomNameTextField.text!, completion: source.refreshRoom)
        }
    }
}

//
//  ErrorAlert.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 24/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit
import Darwin

class ErrorAlert {
    static func CannotConnect(view:UITableViewController)
    {
        let alertController = UIAlertController(title: "Erreur", message: "Le serveur n'est pas joignable, veuillez ré-essayer ultérieurement ...", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Quitter", style: .Destructive, handler: { _ in exit(0) })
        alertController.addAction(yesAction)
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 16/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CinemaController: UITableViewController {

    var cinemaSearchResult:Dictionary<String, Array<Cinema>> = Dictionary<String, Array<Cinema>>();
    var cinema:Dictionary<String, Array<Cinema>> = Dictionary<String, Array<Cinema>>();
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.GetCinema(setCinemas)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func setCinemas(error: String?, cinemas: Array<Cinema>?) -> Void {
        if (error != nil)
        {
            ErrorAlert.CannotConnect(self);
        }
        else
        {
            self.cinema = get_dic(cinemas!)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            });
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            return cinemaSearchResult.keys.count
        }
        return cinema.keys.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.active && searchController.searchBar.text != "") {
            return self.cinemaSearchResult.keys[self.cinemaSearchResult.startIndex.advancedBy(section)].capitalizedString
        }
        return self.cinema.keys[self.cinema.startIndex.advancedBy(section)].capitalizedString;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            return self.cinemaSearchResult[self.cinemaSearchResult.startIndex.advancedBy(section)].1.count
        }
        return self.cinema[self.cinema.startIndex.advancedBy(section)].1.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        print("Row: \(row)")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func get_key_of_index(index:Int) -> String
    {
        if (searchController.active && searchController.searchBar.text != "") {
            return self.cinemaSearchResult.keys[self.cinemaSearchResult.startIndex.advancedBy(index)]
        }
        return self.cinema.keys[self.cinema.startIndex.advancedBy(index)]
    }
    
    func get_dic(cinema:Array<Cinema>) -> Dictionary<String, Array<Cinema>>
    {
        var mySet : Dictionary<String,Array<Cinema>> = Dictionary<String,Array<Cinema>>()
        for (_,value) in cinema.sort({ $0.description < $1.description }).enumerate() {
            if (mySet[value.description] == nil) {
                mySet[value.description] = []
            }
            mySet[value.description]?.append(value)
        }
        
        return mySet
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let section = get_key_of_index(indexPath.section)
        if  searchController.active && searchController.searchBar.text != "" {
            var c:Array<Cinema> = self.cinemaSearchResult[section]!
            cell.textLabel!.text = c[indexPath.row].name.capitalizedString
            cell.detailTextLabel!.text = c[indexPath.row].adresse.capitalizedString
        } else{
            var c:Array<Cinema> = self.cinema[section]!
            cell.textLabel!.text = c[indexPath.row].name.capitalizedString
            cell.detailTextLabel!.text = c[indexPath.row].adresse.capitalizedString
        }
        
        return cell;
    }
    
    func filterContentForSearchText(searchText: String) {
        self.cinemaSearchResult = self.cinema;
        for (_,key) in self.cinema.keys.enumerate() {
            self.cinemaSearchResult[key] = self.cinemaSearchResult[key]!.filter({(aSpecies: Cinema) -> Bool in
                return aSpecies.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ||
                    aSpecies.description.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            });
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let secondViewController = segue.destinationViewController as! RoomsController
            let section = self.get_key_of_index(indexPath.section)
            secondViewController.detailCinema = self.cinema[section]![indexPath.row]
            
        }
    }
}

extension CinemaController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


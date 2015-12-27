//
//  ViewController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 16/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CinemaController: UITableViewController {
    
    var cinemaSearchResult:[(String, Array<Cinema>)] = [(String, Array<Cinema>)]()
    var cinema:[(String, Array<Cinema>)] = [(String, Array<Cinema>)]();
    
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
            self.cinema = get_list(cinemas!)
            
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
            print (cinemaSearchResult.count)
            return cinemaSearchResult.count
        }
        return cinema.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.active && searchController.searchBar.text != "") {
            return self.cinemaSearchResult[section].0.capitalizedString
        }
        return self.cinema[section].0.capitalizedString;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            
            return self.cinemaSearchResult[section].1.count
        }
        return self.cinema[section].1.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func get_list(cinema:Array<Cinema>) -> [(String, Array<Cinema>)]
    {
        var mySet : [(String, Array<Cinema>)] = [(String, Array<Cinema>)]()
        for (_,value) in cinema.enumerate() {
            let idSection = getIndexOfSection(value.description, list: mySet)
            if idSection == -1 {
                mySet.append((value.description, [value]));
            } else {
            mySet[idSection].1.append(value)
            }
        }
        return mySet
    }
    
    func getIndexOfSection(section:String, list:[(String, Array<Cinema>)]) -> Int {
        for (index, value) in list.enumerate() {
            
            if (value.0 == section) {
                return index;
            }
        }
        return -1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CinemaCellController
        let c:Array<Cinema> = (searchController.active && searchController.searchBar.text != "") ? self.cinemaSearchResult[indexPath.section].1 :  self.cinema[indexPath.section].1
        
        cell.title!.text = c[indexPath.row].name.capitalizedString
        cell.subtitle!.text = c[indexPath.row].adresse.capitalizedString
        cell.floatRatingView!.rating = c[indexPath.row].star
        return cell;
    }
    
    func filterContentForSearchText(searchText: String) {
        var tmpCinemaSearchResult = self.cinema;
        self.cinemaSearchResult = [(String, Array<Cinema>)]()
        for (index,_) in self.cinema.enumerate() {
            let resSearch = tmpCinemaSearchResult[index].1.filter({(aSpecies: Cinema) -> Bool in
                return aSpecies.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ||
                    aSpecies.description.lowercaseString.rangeOfString(searchText.lowercaseString) != nil})
            if (resSearch.count > 0)
            {
                let result = (tmpCinemaSearchResult[index].0, resSearch)
                self.cinemaSearchResult.append(result)
            }

        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let secondViewController = segue.destinationViewController as! RoomsController
            if (searchController.active && searchController.searchBar.text != "") {
                secondViewController.detailCinema = self.cinemaSearchResult[indexPath.section].1[indexPath.row]
            }
            else {
                secondViewController.detailCinema = self.cinema[indexPath.section].1[indexPath.row]
            }
            
        }
    }
}

extension CinemaController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


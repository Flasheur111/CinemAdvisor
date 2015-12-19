//
//  ViewController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 16/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class SearchController: UITableViewController {
    var manager:DataManager = DataManager();
    var species:Array<Cinema> = [];
    var speciesSearchResult:Array<Cinema> = [];
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.GetCinema(setCinemas);
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func setCinemas(cinemas: Array<Cinema>) -> Void {
        self.species = cinemas;
        
        dispatch_async(dispatch_get_main_queue(), {
           self.tableView.reloadData()
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Paris !"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.speciesSearchResult.count
        }
        return species.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if  searchController.active && searchController.searchBar.text != "" {
            cell.textLabel!.text = self.speciesSearchResult[indexPath.row].name.lowercaseString
            cell.detailTextLabel!.text = self.speciesSearchResult[indexPath.row].description.lowercaseString
        } else{
            cell.textLabel!.text = self.species[indexPath.row].name.lowercaseString
            cell.detailTextLabel!.text = self.species[indexPath.row].description.lowercaseString
        }
        return cell;
    }
    
    func filterContentForSearchText(searchText: String) {
        if self.species.isEmpty {
            self.speciesSearchResult = [];
            return;
        }
        
        self.speciesSearchResult = self.species.filter({(aSpecies: Cinema) -> Bool in
            return aSpecies.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ||
                    aSpecies.description.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        
        tableView.reloadData()
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


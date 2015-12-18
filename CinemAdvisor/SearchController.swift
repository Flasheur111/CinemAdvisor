//
//  ViewController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 16/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class SearchController: UITableViewController {

    var species:Array<String> = [];
    var speciesSearchResult:Array<String> = [];
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        species = ["un", "deux", "trois"];
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
            cell.textLabel!.text = self.speciesSearchResult[indexPath.row]
        } else{
            cell.textLabel!.text = self.species[indexPath.row]
        }
        return cell;
    }
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.speciesSearchResult.count ?? 0;
        } else {
            return self.species.count ?? 0
        }
    }*/
    
    /*func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell;
        
        var arrayOfSpecies:Array<String>?
        if tableView == self.searchDisplayController?.searchResultsTableView {
            arrayOfSpecies = self.speciesSearchResult
        } else {
            arrayOfSpecies = self.species
        }
        cell.textLabel?.text = "salult"
        
        return cell;
    }*/
    
    func filterContentForSearchText(searchText: String) {
        if self.species == [] {
            self.speciesSearchResult = [];
            return;
        }
        
        self.speciesSearchResult = self.species.filter({(aSpecies: String) -> Bool in
            return aSpecies.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        
        tableView.reloadData()
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


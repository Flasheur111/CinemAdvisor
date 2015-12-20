//
//  DataManager.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 18/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//
import Foundation;

class DataManager {
    var get_cinemas_url = "http://localhost:3000/cinema"
    
    func GetCinema(completion: ((cinema: Array<Cinema>) -> Void))
    {
        var cinemas:Array<Cinema> = []
        
        let url = NSURL(string: get_cinemas_url)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            do
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                for entry in jsonResult {
                    let c:Cinema = Cinema(
                        name: entry["enseigne"] as! String,
                        description: entry["ville"] as! String,
                        cp:entry["dep"] as! Int,
                        longitude: entry["lng"] as! Double,
                        latitude: entry["lat"] as! Double,
                        adresse: entry["adr"] as! String)
                    if (c.description.containsString("PARIS")){
                        cinemas.append(c)
                    }
                }
                cinemas = cinemas.sort { $0.description.compare($1.description) == .OrderedDescending }
                completion(cinema: cinemas);
            } catch _ {}
        });
        
        jsonQuery.resume();
    }
}
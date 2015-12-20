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
    var add_room_url = "http://localhost:3000/room/add/"
    var get_rooms_url = "http://localhost:3000/room/list/"
    
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
                        id: entry["noauto"] as! Int,
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

    func GetRoomsByCinemaId(cinemaId: Int, completion: ((rooms: Array<Room>) -> Void)) {
        var rooms:Array<Room> = []

        let url = NSURL(string: get_rooms_url + String(cinemaId))!
        let urlSession = NSURLSession.sharedSession()

        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }

            do
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                for entry in jsonResult {
                    let room:Room = Room(
                        name: entry["roomname"] as! String,
                        cinemaId: (entry["idcinema"] as! NSString).integerValue)
                    rooms.append(room);
                }
                completion(rooms: rooms);
            } catch _ {}
        });

        jsonQuery.resume();
    }

    func AddRoom(cinemaId: Int, roomName: String, completion: ((room: Room?) -> Void)) {
        var room:Room? = nil
        let encodedRoomName = roomName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let fullUrl: String = add_room_url + String(cinemaId) + "/" + encodedRoomName!
        let url = NSURL(string: fullUrl)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }

            do
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if (jsonResult["error"] as! String == "ok") {
                    room = Room(name: jsonResult["inserted"]!["roomname"] as! String, cinemaId: (jsonResult["inserted"]!["idcinema"] as! NSString).integerValue)
                    completion(room: room!)
                }
                else {
                    print("Error adding room")
                    completion(room: nil)
                }
            } catch _ {}
        });
        
        jsonQuery.resume();
    }
}
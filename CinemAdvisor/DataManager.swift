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
    var add_comment_url = "http://localhost:3000/comment/add/"
    var get_comment_url = "http://localhost:3000/comment/list/"
    
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
                        roomId: entry["_id"] as! String,
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
                    room = Room(roomId: "", name: jsonResult["inserted"]!["roomname"] as! String, cinemaId: (jsonResult["inserted"]!["idcinema"] as! NSString).integerValue)
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
    
    func GetCommentsByCinemaRoomId(cinemaId: Int, roomId: String, completion: ((rooms: Array<Comment>) -> Void)) {
        var comments:Array<Comment> = []
        
        let url = NSURL(string: get_comment_url + String(cinemaId) + "/" + roomId)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            do
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                for entry in jsonResult {
                    let formatDate = NSDateFormatter()
                    formatDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
                    let date = formatDate.dateFromString(entry["date"] as! String);
                    let comment:Comment = Comment(
                        cinemaId: (entry["idcinema"] as! NSString).integerValue,
                        roomId: entry["idroom"] as! String,
                        comment: entry["comment"] as! String,
                        user: entry["user"] as! String,
                        star: (entry["grade"] as! NSString).floatValue,
                        date: date!)
                    comments.append(comment);
                }
                completion(rooms: comments);
            } catch _ {}
        });
        
        jsonQuery.resume();
    }
    
    func AddComment(cinemaId: Int, roomId: String, comment: String, user: String, rate: String) {
        var fullUrl: String = add_comment_url + String(cinemaId) + "/" + String(roomId) +  "/";
        fullUrl += String(comment) + "/" + String(user) + "/" + rate
        
        let url = NSURL(string: fullUrl)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        });
        
        jsonQuery.resume();
    }
}
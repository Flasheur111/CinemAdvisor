 //
 //  DataManager.swift
 //  CinemAdvisor
 //
 //  Created by François BOITEUX on 18/12/2015.
 //  Copyright © 2015 Epita. All rights reserved.
 //
 import Foundation;
 import UIKit;
 
 class DataManager {
    // Local url
    //static let server = "http://localhost:3000"
    // Remote url
    static let server = "http://ns358737.ip-91-121-153.eu:32000"
    
    // Cinemas Routes
    static let get_cinemas_url = "/cinema/list"
    
    // Rooms Routes
    static let add_room_url = "/room/add/"
    static let get_rooms_url = "/room/list/"
    
    // Comments Routes
    static let add_comment_url = "/comment/add/"
    static let get_comment_url = "/comment/list/"
    
    
    static func GetCinema(completion: ((error:String?, cinema: Array<Cinema>?) -> Void))
    {
        var cinemas:Array<Cinema> = []
        
        let url = NSURL(string: server + get_cinemas_url)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                completion(error: "error", cinema: nil);
                return;
            }
            
            do
            {
                if let get_json:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                    
                    let jsonResult  =  get_json as! NSMutableArray
                    
                    for entry in jsonResult {
                        var defaultCity:String = (entry["ville"] as! String)
                        if (defaultCity.containsString("PARIS"))
                        {
                            defaultCity = defaultCity.substringWithRange(Range<String.Index>(start: defaultCity.startIndex.advancedBy(6), end: defaultCity.endIndex.advancedBy(-2)))
                            let c:Cinema = Cinema(
                                id: entry["noauto"] as! Int,
                                name: (entry["enseigne"] as! String),
                                description: defaultCity + "e arrondissement de Paris",
                                cp:entry["dep"] as! Int,
                                longitude: entry["lng"] as! Double,
                                latitude: entry["lat"] as! Double,
                                adresse: entry["adr"] as! String,
                                star: (entry["avg"] as! NSNumber).floatValue)
                            cinemas.append(c)
                        }
                    }
                    completion(error: nil, cinema: cinemas);
                }
            } catch _ {}
        });
        
        jsonQuery.resume();
    }
    
    static func GetRoomsByCinemaId(cinemaId: Int, completion: ((error: String?, rooms: Array<Room>?) -> Void)) {
        var rooms:Array<Room> = []
        
        let url = NSURL(string: server + get_rooms_url + String(cinemaId))!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                completion(error: "error", rooms: nil);
            }
            
            do
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                for entry in jsonResult {
                    let room:Room = Room(
                        roomId: entry["_id"] as! String,
                        name: entry["roomname"] as! String,
                        cinemaId: (entry["idcinema"] as! NSString).integerValue,
                        grade: (entry["avg"] as! NSNumber).floatValue)
                    rooms.append(room);
                }
                completion(error: nil, rooms: rooms);
            } catch _ {}
        });
        
        jsonQuery.resume();
    }
    
    static func AddRoom(cinemaId: Int, roomName: String, completion: ((error: String?) -> Void)) {
        let encodedRoomName = roomName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let fullUrl: String = server + add_room_url + String(cinemaId) + "/" + encodedRoomName!
        let url = NSURL(string: fullUrl)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                completion(error: error?.description)
                return;
            }
            completion(error: nil);
            
        });
        
        jsonQuery.resume();
    }
    
    static func GetCommentsByCinemaRoomId(cinemaId: Int, roomId: String, completion: ((rooms: Array<Comment>) -> Void)) {
        var comments:Array<Comment> = []
        
        let url = NSURL(string: server + get_comment_url + String(cinemaId) + "/" + roomId)!
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
                        star: entry["grade"] as! Float32,
                        date: date!)
                    comments.append(comment);
                }
                completion(rooms: comments);
            } catch let error{
                print(error);
            }
        });
        
        jsonQuery.resume();
    }
    
    static func AddComment(cinemaId: Int, roomId: String, comment: String, user: String, rate: String, completion: (error: String?) -> Void) {
        var fullUrl: String = server + add_comment_url + String(cinemaId) + "/" + String(roomId) +  "/";
        fullUrl += String(comment).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "/"
        fullUrl += String(user).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "/"
        fullUrl += rate
        let url = NSURL(string: fullUrl)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                completion(error: error?.description);
                return;
            }
            completion(error: nil)
        });
        
        jsonQuery.resume();
    }
 }
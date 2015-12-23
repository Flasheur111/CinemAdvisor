//
//  Comment
//  CinemAdvisor
//
//  Created by Camille Dollé on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//
import UIKit

class Comment {
    let cinemaId: Int;
    let roomId: String;
    
    let comment: String;
    let user:String;
    let star:Float32;
    let date:NSDate;
    
    init(cinemaId: Int, roomId:String, comment: String, user:String, star: Float32, date:NSDate){
        self.cinemaId = cinemaId;
        self.roomId = roomId;
        
        self.comment = comment;
        self.user = user;
        self.star = star;
        self.date = date;
    }
}

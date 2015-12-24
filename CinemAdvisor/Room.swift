//
//  Room.swift
//  CinemAdvisor
//
//  Created by Camille Dollé on 20/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

class Room {
    let roomId: String;
    let name: String;
    let grade: Float32
    
    var cinemaId:Int;
    
    init(roomId: String, name: String, cinemaId:Int, grade:Float32){
        self.roomId = roomId
        self.name = name
        self.cinemaId = cinemaId
        self.grade = grade
    }
}

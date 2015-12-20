//
//  Cinema.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 18/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

class Cinema {
    let name: String;
    let description: String;
    var cp:Int;
    var longitude:Double;
    var latitude:Double;
    var adresse: String;
    
    init(name: String, description: String, cp:Int, longitude: Double, latitude: Double, adresse: String){
        self.name = name
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.cp = cp;
        self.adresse = adresse;
    }
}
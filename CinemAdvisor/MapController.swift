//
//  MapController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 19/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let idf = CLLocationCoordinate2D(
            latitude:48.8584197,
            longitude:2.3495340
        )
        
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(idf, span)
        mapView.setRegion(region, animated:true)
        DataManager.GetCinema(loadCinema);
    }
    
    func loadCinema(error: String?, cinema:Array<Cinema>?) -> Void
    {
        if error == nil
        {
            dispatch_async(dispatch_get_main_queue(), {
            for c in cinema! {
                let location = CLLocationCoordinate2D(
                    latitude: c.latitude,
                    longitude: c.longitude
                )
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = c.name
                annotation.subtitle = c.description
                self.mapView.addAnnotation(annotation)
            }
            });
        }
    }
}

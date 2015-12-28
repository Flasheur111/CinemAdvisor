//
//  MapController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 19/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var cinemas: Array<Cinema>?
    var cinemaNameClicked: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        var currentCoord = locationManager.location?.coordinate
        
        if (currentCoord == nil)
        {
            currentCoord = CLLocationCoordinate2D(
                latitude:48.8584197,
                longitude:2.3495340
            )
        }
        
        mapView.showsUserLocation = true;
        
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(currentCoord!, span)
        mapView.setRegion(region, animated:true)
        DataManager.GetCinema(loadCinema);
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "Cinema"
        
        if annotation.isKindOfClass(MKPointAnnotation.self) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    
    func mapView(MapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            cinemaNameClicked = (annotationView.annotation?.title)!
            performSegueWithIdentifier("goToCinemaDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToCinemaDetail" {
            var cineToSearch: Cinema?
            if let cinemasToEnumerate = self.cinemas, cinemaName = cinemaNameClicked {
                cineToSearch = cinemasToEnumerate.filter({(cine: Cinema) -> Bool in
                    return (cine.name.lowercaseString == cinemaName.lowercaseString)
                }).first
            }
            let secondViewController = segue.destinationViewController as! RoomsController
            secondViewController.detailCinema = cineToSearch
        }
    }
    
    func loadCinema(error: String?, cinema:Array<Cinema>?) -> Void
    {
        self.cinemas = cinema
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

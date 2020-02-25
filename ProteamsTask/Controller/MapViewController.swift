//
//  ViewController.swift
//  ProteamsTask
//
//  Created by Massimiliano on 25/01/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate ,GetDataDelegate {
    
    
 
    
    
    
    @IBOutlet weak var mapLocation: MKMapView!
    
    
    var callLocations = LocationsModel()
    var locationsItem = [LocationsItem]()
    var location:  CLLocationCoordinate2D?
    var initialLatitudeDelat: Double?
    var initialLongitudeDelat: Double?
    let parameters = ["latitudeNorth":"51.54126776718752", "latitudeSouth":"51.48964361688991", "longitudeEast":"-0.1391464811950982", "longitudeWest":"-0.1890868820194953"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callLocations.delegate = self
        mapLocation.delegate = self
        callLocations.getData(parameters: parameters)
        setRegion()
    }
    
    
    //MARK: - GetDataDelegate
    
    func getLocationsArray(data: [LocationsItem]) {
        DispatchQueue.main.async {
            self.locationsItem = data
            self.getAnnotations()
        }
            
        
        
    }
    
    func setRegion (){
        let latitudeNorth = 51.54126776718752
        let latitudeSouth = 51.48964361688991
        let longitudeEast = -0.1391464811950982
        let longitudeWest = -0.1890868820194953
        
        location = CLLocationCoordinate2D(latitude: (latitudeNorth + latitudeSouth) / 2, longitude: (longitudeEast + longitudeWest) / 2)
        let region = MKCoordinateRegion(center: location!, latitudinalMeters: 3000, longitudinalMeters: 3000)
        initialLatitudeDelat = region.span.latitudeDelta
        initialLongitudeDelat = region.span.longitudeDelta
        mapLocation.setRegion(region, animated: true)
    }
    


    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let latitudeDelta = mapLocation.region.center.latitude
        let longitudeDelta = mapLocation.region.center.longitude

            let latitudeNorth = latitudeDelta + mapLocation.region.span.latitudeDelta
            let latitudeSouth = latitudeDelta - mapLocation.region.span.latitudeDelta
            let longitudeEast = longitudeDelta + mapLocation.region.span.longitudeDelta
            let longitudeWest = longitudeDelta - mapLocation.region.span.longitudeDelta
            let parameter = ["latitudeNorth":"\(latitudeNorth)", "latitudeSouth":"\(latitudeSouth)", "longitudeEast":"\(longitudeEast)", "longitudeWest":"\(longitudeWest)"]
        
        DispatchQueue.main.async {
            self.callLocations.getData(parameters: parameter)
            
        }
    }
    
   
    
    //MARK: - Get Annotations
    
    func getAnnotations(){
        var arrayAnnotation = [MKPointAnnotation]()
        mapLocation.removeAnnotations(arrayAnnotation)
        locationsItem.forEach({location in
            let annotations = MKPointAnnotation()
            annotations.title = location.SchoolName
            let lat = Double(location.latitude)!
            let long = Double(location.longitude)!

            annotations.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            arrayAnnotation.append(annotations)
            mapLocation.addAnnotations(arrayAnnotation)
        })
    }
    
    
    
}


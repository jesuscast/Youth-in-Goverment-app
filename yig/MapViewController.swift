//
//  MapViewController.swift
//  yig
//
//  Created by Macbook on 10/18/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

class Point: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

class PointSelected: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

class MapViewController:UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    var AnnotationsColors = [
        "Gervais side, upper right": MKPinAnnotationColor.Red,
        "Gervais side, upper left": MKPinAnnotationColor.Red,
       "Gervais side, bottom right": MKPinAnnotationColor.Red,
        "Gervais side, bottom left": MKPinAnnotationColor.Red,
        "Confederate Statue": MKPinAnnotationColor.Red,
        "Pendleton side, upper right": MKPinAnnotationColor.Red,
        "Pendleton side, upper left": MKPinAnnotationColor.Red,
        "Pendleton side, bottom left": MKPinAnnotationColor.Red,
        "Pendleton side, bottom right": MKPinAnnotationColor.Red,
        "Richardson Square": MKPinAnnotationColor.Red,
        "Wade Hampton Statue": MKPinAnnotationColor.Red,
        "Calhoun Building": MKPinAnnotationColor.Red,
        "Thurmond Statue": MKPinAnnotationColor.Red,
        "Capital Memorial": MKPinAnnotationColor.Red,
        "Garage ramp—entry": MKPinAnnotationColor.Red,
        "Garage ramp—exit": MKPinAnnotationColor.Red,
        "Liberty Bell": MKPinAnnotationColor.Red,
        "Brown Bldg. Benches": MKPinAnnotationColor.Red,
        "Brown Bldg. Entrance": MKPinAnnotationColor.Red
        
    ]
    var allAnnotations: [String : MKAnnotation] = [String : MKAnnotation]()
    // Variables for search bar
    var searchActive : Bool = false
    var dataTwo = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[Int] = []
    var tableViewWithOptions = UITableView()
    var itemsInTableSearch = [String]()
    var previouslySelectedPin = ""
    let data = [
        [
            "title": "Gervais side, bottom left",
            "locationName": "Gervais side, bottom left",
            "discipline": "",
            "latitude": 34.000713,
            "longitude": -81.033153
        ],
        [
            "title": "Gervais side, upper left",
            "locationName": "Gervais side, upper left",
            "discipline": "",
            "latitude": 34.000578,
            "longitude": -81.033098
        ], // 34.000578, -81.033098
        [
            "title": "Gervais side, bottom right",
            "locationName": "Gervais side, bottom right",
            "discipline": "",
            "latitude": 34.000639,
            "longitude": -81.033403
        ], // 34.000639, -81.033403
        [
            "title": "Gervais side, upper left",
            "locationName": "Gervais side, bottom left",
            "discipline": "",
            "latitude": 34.000507,
            "longitude": -81.033333
        ], // 34.000507, -81.033333
        [
            "title": "Confederate Statue",
            "locationName": "Confederate Statue",
            "discipline": "",
            "latitude": 34.001058,
            "longitude": -81.033443
        ], // 34.001058, -81.033443
        [
            "title": "Pendleton side, upper right",
            "locationName": "Pendleton side, upper right",
            "discipline": "",
            "latitude": 34.000138,
            "longitude": -81.032923
        ], // 34.000138, -81.032923
        [
            "title": "Pendleton side, upper left",
            "locationName": "Pendleton side, upper left",
            "discipline": "",
            "latitude": 34.000074,
            "longitude": -81.033130
        ], // 34.000074, -81.033130
        [
            "title": "Pendleton side, bottom left",
            "locationName": "Pendleton side, bottom left",
            "discipline": "",
            "latitude": 33.999945,
            "longitude": -81.033048
        ], // 33.999945, -81.033048
        [
            "title": "Pendleton side, bottom right",
            "locationName": "Pendleton side, bottom right",
            "discipline": "",
            "latitude": 33.999994,
            "longitude": -81.032868
        ], // 33.999994, -81.032868
        [
            "title": "Richardson Square",
            "locationName": "Richardson Square",
            "discipline": "",
            "latitude": 33.999544,
            "longitude": -81.032778
        ], // 33.999544, -81.032778
        [
            "title": "Wade Hampton Statue",
            "locationName": "Wade Hampton Statue",
            "discipline": "",
            "latitude": 33.999923,
            "longitude": -81.032303
        ], // 33.999923, -81.032303
        [
            "title": "Calhoun Building",
            "locationName": "Calhoun Building",
            "discipline": "",
            "latitude": 33.999794,
            "longitude": -81.031510
        ], // 33.999794, -81.031510
        [
            "title": "Thurmond Statue",
            "locationName": "Thurmond Statue",
            "discipline": "",
            "latitude": 33.999292,
            "longitude": -81.032656
        ], // 33.999292, -81.032656
        [
            "title": "Capital Memorial",
            "locationName": "Capital Memorial",
            "discipline": "",
            "latitude": 33.999072,
            "longitude": -81.032568
        ], // 33.999072, -81.032568
        [
            "title": "Garage ramp—entry",
            "locationName": "Garage ramp—entry",
            "discipline": "",
            "latitude": 33.998631,
            "longitude": -81.032273
        ], // 33.998631, -81.032273
        [
            "title": "Garage ramp—exit",
            "locationName": "Garage ramp—exit",
            "discipline": "",
            "latitude": 33.998557,
            "longitude": -81.032448
        ], // 33.998557, -81.032448
        [
            "title": "Liberty Bell",
            "locationName": "Liberty Bell",
            "discipline": "",
            "latitude": 33.999154,
            "longitude": -81.032332
        ], // 33.999154, -81.032332
        [
            "title": "Brown Bldg. Benches",
            "locationName": "Brown Bldg. Benches",
            "discipline": "",
            "latitude": 33.999291,
            "longitude": -81.031844
        ], // 33.999291, -81.031844
        [
            "title": "Brown Bldg. Entrance",
            "locationName": "Brown Bldg. Entrance",
            "discipline": "",
            "latitude": 33.999281,
            "longitude": -81.031335
        ], // 33.999281, -81.031335
        [
            "title": "Brown Bldg. Entrance",
            "locationName": "Brown Bldg. Entrance",
            "discipline": "",
            "latitude": 33.999281,
            "longitude": -81.031335
        ], // 33.999281, -81.031335
    ]
    var content = UIView()
    var imageMap = UIImageView(image: UIImage(named: "map.png"))
    var map = MKMapView()
    var search = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let screenRect = UIScreen.mainScreen().bounds
        let h = screenRect.size.height
        let w = screenRect.size.width
        content.frame = CGRectMake(0, 65, w, h-65)
        content.backgroundColor = UIColor.whiteColor()
        search.frame = CGRect(x: 0, y: 0, width: w, height: 100)
        map.frame.size.width = w
        map.frame.size.height = h-165
        map.frame.origin.x = 0
        map.frame.origin.y = 100
        map.mapType = MKMapType.Satellite
        // Set up the position of the map
        let initialLocation = CLLocation(latitude: 34.000272, longitude: -81.033063)
        let regionRadius: CLLocationDistance = 150
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        map.camera.heading = 159.5
        // Add all 21 points to the map
        // 1
        map.delegate = self
        for point in data {
            let titleTemp = String(point["title"]!)
            allAnnotations[titleTemp] = Point(title: titleTemp,
                locationName: String(point["locationName"]!),
                discipline: String(point["discipline"]!),
                coordinate: CLLocationCoordinate2D(latitude: Double(point["latitude"]! as! Double), longitude: Double(point["longitude"]! as! Double)))
            // stateHouseSteps1.
            map.addAnnotation(allAnnotations[titleTemp]!)
        }
        // Set up the searh bar
        search.delegate = self
        // Set up contents
        content.addSubview(search)
        content.addSubview(map)
        self.view.addSubview(content)
        
        
        tableViewWithOptions.delegate      =   self
        tableViewWithOptions.dataSource    =   self
        content.addSubview(tableViewWithOptions)
        tableViewWithOptions.frame = CGRect(x: 0, y: 65, width: w, height: 0)
        
        dataTwo = [String]()
        for element in data {
            dataTwo.append(element["title"] as! String)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Point {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                // view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            NSLog("\(annotation.title)")
            if let possibleTitle = annotation.title {
                view.pinColor = AnnotationsColors[possibleTitle]!
            }
            //MKPinAnnotationColor.Green
            return view
        }
        return nil
    }
    // Search bar overriding of functions start
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var organizedElements = [String]()
        for(var i = 0; i < dataTwo.count ; i++) {
            let text = dataTwo[i]
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            if (range.location != NSNotFound) {
                organizedElements.append(dataTwo[i])
            }
        }
        if(organizedElements.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        itemsInTableSearch = organizedElements
        tableViewWithOptions.frame.size.height = CGFloat(Float(45 * itemsInTableSearch.count))
        tableViewWithOptions.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell()
        
        if (itemsInTableSearch.count != 0) {
            cell.textLabel?.text = itemsInTableSearch[indexPath.row]
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return itemsInTableSearch.count
        }
        return dataTwo.count;
        
        
        // return itemsInTableSearch.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let titleTemp = itemsInTableSearch[indexPath.row]
        let annotationTemp = allAnnotations[titleTemp]
        map.removeAnnotation(annotationTemp!)
        AnnotationsColors[titleTemp] = MKPinAnnotationColor.Purple
        map.addAnnotation(annotationTemp!)
        if (previouslySelectedPin != "") {
            let annotationPrevious = allAnnotations[previouslySelectedPin]
            map.removeAnnotation(annotationPrevious!)
            AnnotationsColors[previouslySelectedPin] = MKPinAnnotationColor.Red
            map.addAnnotation(annotationPrevious!)
        }
        previouslySelectedPin = titleTemp
    }
    
    
    
    // Search bar overriding of functions end
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
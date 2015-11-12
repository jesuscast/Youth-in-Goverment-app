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
    var AnnotationsColors: [ String : MKPinAnnotationColor ] = [ String : MKPinAnnotationColor ]()
    var allAnnotations: [String : MKAnnotation] = [String : MKAnnotation]()
    // Variables for search bar
    var searchActive : Bool = false
    var dataTwo: [String] = [String]()
    var filtered:[Int] = []
    var tableViewWithOptions = UITableView()
    var itemsInTableSearch = [String]()
    var backend = Backend()
    var previouslySelectedPin = ""
    var data:[ [ String : NSObject ] ] = [ [ String : NSObject ] ]()
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
        overrideFirebaseCallbacks()
        backend.registerListeners()
        //Looks for single or multiple taps.
        // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        // view.addGestureRecognizer(tap)
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
        search.text = titleTemp
        // map.removeAnnotation(annotationTemp!)
        if (previouslySelectedPin != "") {
            let annotationPrevious = allAnnotations[previouslySelectedPin]
            map.removeAnnotation(annotationPrevious!)
            // AnnotationsColors[previouslySelectedPin] = MKPinAnnotationColor.Red
            // map.addAnnotation(annotationPrevious!)
        }
        AnnotationsColors[titleTemp] = MKPinAnnotationColor.Green
        map.addAnnotation(annotationTemp!)
        previouslySelectedPin = titleTemp
        tableViewWithOptions.frame.size.height = 0
        dismissKeyboard()
    }
    
    struct Objects {
    
    var sectionName : String!
    var sectionObjects : [(String,String)]!
    
    }
    
    struct firebaseElement {
        var key: String!
        var data: [String:String]!
    }
    
     var firebaseData: [String: [ String : String ] ]? = nil
    
    func overrideFirebaseCallbacks() {
        let announcementsType = "annotations"
        NSLog("overriding firebase calls")
        backend.options[announcementsType] = {
            (snapshot: FDataSnapshot) -> Void in
            
            NSLog("SNAPSHOT \(snapshot)")
            if let valueOfSnapshot = snapshot.value as! [ String : [String : String] ]? {
                for (key, value) in valueOfSnapshot {
                    if (self.firebaseData==nil) {
                        self.firebaseData = ["TEST":["HELLO":"NOTHING"]]
                    }
                    if self.firebaseData![key] == nil {
                        self.firebaseData![key] = value
                    }
                }
            }
            
            var firebaseOrdered:[ [ String : NSObject] ] = [ [ String : NSObject] ]()
            for (key, value) in self.firebaseData! {
                if(key != "TEST"){
                    firebaseOrdered.append(value)
                    
                }
            }
            
            self.data = firebaseOrdered
            
            self.dataTwo = [String]()
            for element in self.data {
                self.dataTwo.append(element["title"] as! String)
                self.AnnotationsColors[ element["title"] as! String] = MKPinAnnotationColor.Red
            }
            for point in self.data {
                NSLog("sdasd\(point)")
                let titleTemp = String(point["title"]!)
                let latTemp: Double = Double(point["latitude"]! as! String)!
                let longTemp = Double(point["longitude"]! as! String)!
                self.allAnnotations[titleTemp] = Point(title: titleTemp,
                    locationName: String(point["locationName"]!),
                    discipline: String(point["discipline"]!),
                    coordinate: CLLocationCoordinate2D(latitude: latTemp, longitude: longTemp )
                )
                // stateHouseSteps1.
                // self.map.addAnnotation(self.allAnnotations[titleTemp]!)
            }
        }
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Search bar overriding of functions end
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//
//  LocationChooseViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 1.05.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit
import MapKit

class LocationChooseViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {


    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    let apiMethods = ApiMethods()
    var list = [MKPointAnnotation]()
    var currountLocation: MKAnnotation!
    var backUIVC: CreateEventViewController!
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let geocoder = CLGeocoder();
        myMapView.removeAnnotations(list)
        list = [MKPointAnnotation]()
        
        
        geocoder.geocodeAddressString(mySearchBar.text, completionHandler: { (placemarkss, error) -> Void in
        if placemarkss != nil {
            var region = MKCoordinateRegion()
            var placemarks: [CLPlacemark] = placemarkss as! [CLPlacemark]
            var placemark = placemarks[0]
            var newLocation = placemark.location.coordinate
            region.center = newLocation
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newLocation
            annotation.title = placemark.name
            
            self.list.append(annotation)
            self.myMapView.addAnnotation(annotation)
            //self.get()
            if self.list.count == 1{
                self.myMapView.selectAnnotation(self.list[0], animated: true)
            }
            
            self.myMapView.showAnnotations(self.list, animated: true)
            }
        })
        
        
        
        
        
        
        
       
    }
    
    func get(){
        var sanFrancisco = CLLocationCoordinate2D(latitude: 37.774929, longitude: -122.419416)
        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        var span = MKCoordinateSpanMake(0.5, 0.5)
        request.region = MKCoordinateRegionMake(list[0].coordinate, span)
        var search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) -> Void in
            println(response.mapItems)
            /*if response != nil && response.mapItems != nil {
            var region = MKCoordinateRegion()
            var placemarks: [CLPlacemark] = response.mapItems as! [CLPlacemark]
            var placemark = placemarks[0]
            var newLocation = placemark.location.coordinate
            region.center = newLocation
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newLocation
            annotation.title = placemark.name
            
            self.list.append(annotation)
            self.myMapView.addAnnotation(annotation)
            
            if placemarks.count == 1{
            self.myMapView.selectAnnotation(annotation, animated: true)
            }
            
            self.myMapView.showAnnotations(self.list, animated: true)
            }*/
            
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let currLocation = view.annotation {
            currountLocation = currLocation
            navItem.title = currountLocation.title
        }
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        if currountLocation != nil {
            backUIVC.currountLocation = currountLocation
            backUIVC.locationTapped()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

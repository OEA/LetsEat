//
//  RestaurantLocationViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 13.04.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RestaurantLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            /*
            let span  = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.028793, 29.259657) , span)
            self.mapView.setRegion(region, animated: true)*/
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(41.026756, 29.219937)
            annotation.title = "Aras Et"
            //annotation.subtitle = "Bilim Yuvasi"
            self.mapView.addAnnotation(annotation)
            
            let span  = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(annotation.coordinate , span)
            self.mapView.setRegion(region, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        NSLog("%@", region)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
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

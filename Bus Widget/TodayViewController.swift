//
//  TodayViewController.swift
//  Bus Widget
//
//  Created by Davide Spadini on 15/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var updateResult:NCUpdateResult = NCUpdateResult.NoData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
//        latitudeLabel.text = "Boooooh"
//        longitudeLabel.text = "Booooooh"
        println("Widget called")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        println("Widget called")
        var currentSize: CGSize = self.preferredContentSize
        currentSize.height = 50.0
        self.preferredContentSize = currentSize
        //performWidgetUpdate()
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        performWidgetUpdate()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = locations[locations.count - 1] as? CLLocation
    }
    
    func performWidgetUpdate() {
        println("performWidgetUpdate called")
        if currentLocation != nil {
            NSLog("currentLocation is set")
            var latitudeText = String(format: "Lat: %.4f", currentLocation!.coordinate.latitude)
            var longitudeText = String(format: "Lon: %.4f", currentLocation!.coordinate.longitude)
            
            var lat = String(format: "%.4f", currentLocation!.coordinate.latitude)
            var lon = String(format: "%.4f", currentLocation!.coordinate.longitude)
            
            NSLog(latitudeText)
            NSLog(longitudeText)
            
            latitudeLabel.text = latitudeText
            longitudeLabel.text = longitudeText

            //self.near_stop(latitudeText, longitude: longitudeText)
            self.near_stop(lat, longitude: lon)
        }
        self.near_stop("000", longitude: "000")
    }
    
    func near_stop(latitude: String, longitude: String) {
        NSLog("I'm in!!")
        println("Im in!!")
        self.stopLabel.text = "Loading....."
        self.latitudeLabel.text = "Ciao"
        self.longitudeLabel.text = "Ciao"
        
//        let urlPath = "http://gtfs-provider.herokuapp.com/api/stopsNearby/" + latitude + "/" + longitude + "/0.1"
        let urlPath = "http://gtfs-provider2.herokuapp.com/api/stopsNearby/46.0553/11.1190/0.2"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {

//                println(jsonResult)
                var res: NSArray = jsonResult["stops"] as! NSArray
                
//                println(res)
                println(res[0]["stop_name"])
                
                dispatch_async (dispatch_get_main_queue ()) {
                    self.stopLabel.text = res[0]["stop_name"] as? String
                }

            } else {
                println("JSON Error \(err!.localizedDescription)")
            }
            
        })
        
        task.resume()
        
    }
    
}

//
//  BusDetailTableViewController.swift
//  Bus
//
//  Created by Davide Spadini on 14/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusDetailTableViewController: UITableViewController {
    var tableDirections = []
    var to_send = []
    var route_id: String?
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let a = route_id {
            showDirections()
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableDirections.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier( "BusDetailCell", forIndexPath: indexPath) as! BusDetailTableViewCell
        
        let direction: AnyObject = self.tableDirections[indexPath.row]
        cell.busDetailLabel.text = direction as? String
        
        return cell
    }
    
    func showDirections(){
        let urlPath = "http://gtfs-provider.herokuapp.com/api/stops/trentino-trasporti-esercizio-spa/" + route_id!
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?

            if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray{
                
                self.to_send = jsonResult
                
                var result : Array = ["", ""]
                
                var dir_0: NSArray = jsonResult[0]["stops"] as! NSArray
                var len_dir_0 = dir_0.count - 1
                var from_0 = dir_0[0]["stop_name"] as! String
                var to_0 = dir_0[len_dir_0]["stop_name"] as! String
                var from = "From " + from_0 + "\nto " + to_0
                
                if (from_0 != to_0){
                    result[0] = from
                } else {
                    result[0] = "Circolare"
                }
                
                if jsonResult.count == 2 {
                    var dir_1: NSArray = jsonResult[1]["stops"] as! NSArray
                    var len_dir_1 = dir_1.count - 1
                    var from_1 = dir_1[0]["stop_name"] as! String
                    var to_1 = dir_1[len_dir_1]["stop_name"] as! String
                    var to = "From " + from_1 + "\nto " + to_1
                    
                    result[1] = to
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableDirections = result
                    self.tableView.reloadData()
                })
                
            } else {
                println("JSON Error \(err!.localizedDescription)")
            }
            
        })
        
        task.resume()

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showStops"{
            let busStopsController = segue.destinationViewController as! BusStopsTableViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow()
            let row = myIndexPath?.row
            busStopsController.direction = row
            busStopsController.recv = self.to_send[row!]["stops"] as! NSArray
            busStopsController.route_id = self.route_id
        }
    }

}

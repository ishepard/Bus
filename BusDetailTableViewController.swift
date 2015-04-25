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
    var route_short_name : String?
    var route_color : String?
    var route_long_name :String?
    var direction_0 = [NSDictionary]()
    var direction_1 = [NSDictionary]()
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
        return self.tableDirections.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier( "BusDetailCell", forIndexPath: indexPath) as! BusDetailTableViewCell
        
//        let direction: AnyObject = self.tableDirections[indexPath.row]
//        cell.busDetailLabel.text = direction as? String
        let direction = self.tableDirections[indexPath.row] as! String
        cell.busDetailLabel.text = direction

        
        return cell
    }
    
    func showDirections(){
        let urlPath = "http://waiting-for-the-bus.herokuapp.com/api/stops/trentino-trasporti-esercizio-spa/" + route_id!
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
                
                var res: NSArray = jsonResult["stops"] as! NSArray
                
                for e in res{
                    var el: Int = e["direction_id"] as! Int
                    if (el == 0){
                        self.direction_0.append(e as! NSDictionary)
                    } else if (el == 1){
                        self.direction_1.append(e as! NSDictionary)
                    }
                }
                
//                println(self.direction_0)
//                println(self.direction_1)
                
                var result: NSMutableArray = []
                
                // Andata
                var from = self.direction_0[0]["stop_name"] as! String
                var to = self.direction_0[self.direction_0.count - 1]["stop_name"] as! String
                
                if (from == to){
                    result.addObject("Circolare")
                } else {
                    result.addObject("From " + from + " to " + to)
                }
                
                // Se c'è, aggiungo il ritorno
                if (self.direction_1.count != 0){
                    from = self.direction_1[0]["stop_name"] as! String
                    to = self.direction_1[self.direction_1.count - 1]["stop_name"] as! String
                    result.addObject("From " + from + " to " + to)
                }
//                println(result)
                
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
            busStopsController.direction_name = self.tableDirections[row!] as? String
            if (row == 0){
                busStopsController.recv = self.direction_0
            } else if (row == 1){
                busStopsController.recv = self.direction_1
            }

            busStopsController.route_id = self.route_id
            busStopsController.route_short_name = self.route_short_name
            busStopsController.route_color = self.route_color
            busStopsController.route_long_name = self.route_long_name
        }
    }

}

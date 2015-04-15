//
//  BusScheduleTableViewController.swift
//  Bus
//
//  Created by Davide Spadini on 15/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusScheduleTableViewController: UITableViewController {
    var stop_id : String?
    var route_id : String?
    var direction : Int?
    var tableSchedule = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let a = route_id {
            println(a)
            println(self.stop_id)
            getSchedule()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func getSchedule(){
        let dir : String = String(direction!)
        let urlPath = "http://gtfs-provider.herokuapp.com/api/times/trentino-trasporti-esercizio-spa/" + route_id! + "/" + stop_id! + "/" + dir
        println(urlPath)
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray {
            
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableSchedule = jsonResult
                    self.tableView.reloadData()
                })
            }  else {
                // If there is an error parsing JSON, print it to the console
                println("JSON ERROR")
            }
        })
        
        task.resume()
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
        return tableSchedule.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusScheduleCell", forIndexPath: indexPath) as! BusScheduleTableViewCell
        
        var myString: String = tableSchedule[indexPath.row] as! String
        var myStringArr = myString.componentsSeparatedByString(":")
        var res : String = myStringArr[0] + ":" + myStringArr[1]
        
        cell.busScheduleLabel.text = res

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

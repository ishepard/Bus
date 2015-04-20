//
//  BusStopsTableViewController.swift
//  Bus
//
//  Created by Davide Spadini on 15/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusStopsTableViewController: UITableViewController {
    var direction : Int?
    var recv : NSArray = []
    var route_id : String?
    var route_short_name : String?
    var route_color : String?
    var route_long_name :String?
    var direction_name : String?
    var favorite: [Dictionary<String, NSString>] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let a = direction {
            self.tableView.reloadData()
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // TO CANCEL
        // defaults.removeObjectForKey("obj")
        
        
        if let obj: NSArray = defaults.arrayForKey("obj"){
            self.favorite = obj as! [Dictionary<String, NSString>]
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj: NSArray = defaults.arrayForKey("obj"){
            self.favorite = obj as! [Dictionary<String, NSString>]
        }
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
        //println(recv.count)
        return recv.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusStopCell", forIndexPath: indexPath) as! BusStopsTableViewCell

        //cell.busStopCell.text = recv[direction!]["stop_name"] as! String
        // Configure the cell...
        cell.busStopCell.text = recv[indexPath.row]["stop_name"] as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        let saveClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
//            println("Save closure called")
//            println(self.route_id)
//            println(self.route_short_name)
//            println(self.route_long_name)
//            println(self.route_color)
//            println(self.direction)
            let alert = UIAlertController(title: "Added to Favorites", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let Reportbutton = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel , handler: nil)
            alert.addAction(Reportbutton)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            var stop_id = self.recv[indexPath.row]["stop_id"] as? String
            println(stop_id)
            var stop_name = self.recv[indexPath.row]["stop_name"] as? String
            println(stop_name)
            self.prepare_storage(self.route_id!, route_short_name: self.route_short_name!, route_color: self.route_color!, route_long_name: self.route_long_name!, direction: self.direction!,direction_name: self.direction_name!, stop_id: stop_id!, stop_name: stop_name!)
            self.tableView.setEditing(false, animated: true)
        }
        
        let saveAction = UITableViewRowAction(style: .Normal, title: "Add", handler: saveClosure)
        
        return [saveAction]
    }
    
    func prepare_storage(route_id: NSString, route_short_name: NSString, route_color: NSString, route_long_name: NSString, direction: Int, direction_name: NSString, stop_id: NSString, stop_name: NSString){
        var dir : NSString = String(direction)
        var dict: [String: NSString] = ["route_id": route_id, "route_short_name": route_short_name, "route_color": route_color, "route_long_name": route_long_name, "direction": dir, "stop_id" : stop_id, "stop_name": stop_name, "direction_name": direction_name]
        var to_append = true
        println(dict)
        for n in self.favorite{
            println(n)
            if (n["route_id"] == dict["route_id"] && n["stop_id"] == dict["stop_id"]){
                to_append = false
                println("I haven't to append")
                break
            }
        }
        if (to_append == true ){
            self.favorite.append(dict)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.favorite, forKey: "obj")
    }
    

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
        if segue.identifier == "showSchedule"{
            let busScheduleController = segue.destinationViewController as! BusScheduleTableViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow()
            let row = myIndexPath?.row
            busScheduleController.stop_id = recv[row!]["stop_id"] as? String
            busScheduleController.route_id = self.route_id
            busScheduleController.direction = self.direction
        }
    }

}

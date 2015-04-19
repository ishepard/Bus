//
//  BusTableViewController.swift
//  Bus
//
//  Created by Davide Spadini on 13/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusTableViewController: UITableViewController {
    var tableData: [Dictionary<String,String>] = []
    var favorite: [Dictionary<String, NSString>] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // TO CANCEL
        // defaults.removeObjectForKey("obj")
        
        
        if let obj: NSArray = defaults.arrayForKey("obj"){
            self.favorite = obj as! [Dictionary<String, NSString>]
        }

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        list_of_bus("/api/routes/trentino-trasporti-esercizio-spa")
        self.tableView.scrollEnabled = true

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
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier( "BusTableCell", forIndexPath: indexPath) as! BusTableViewCell
        let rowData = self.tableData[indexPath.row]
        var route_short_name: NSString = rowData["route_short_name"] as! NSString
        var route_color: NSString = rowData["route_color"] as! NSString
        var route_long_name: NSString = rowData["route_long_name"] as! NSString
        
        // cell.busLabel.font = UIFont.boldSystemFontOfSize(30)
        cell.busLabel.text = route_long_name as String
        
        cell.busLabelImage.font = UIFont.boldSystemFontOfSize(50)
        cell.busLabelImage.textColor = UIColor.whiteColor()
        cell.busLabelImage.text = route_short_name as String

        var background_color = UIColor.blackColor()
        
        if (route_color != ""){
            var red = route_color .substringWithRange(NSMakeRange(0, 2))
            var green = route_color .substringWithRange(NSMakeRange(2, 2))
            var blue = route_color .substringWithRange(NSMakeRange(4, 2))
            var red_float = CGFloat(strtoul(red, nil, 16)) / 255.0
            var green_float = CGFloat(strtoul(green, nil, 16)) / 255.0
            var blue_float = CGFloat(strtoul(blue, nil, 16)) / 255.0
            background_color = UIColor(
                red: red_float,
                green: green_float,
                blue: blue_float,
                alpha: CGFloat(1.0)
            )
        }
        cell.busLabel.textColor = background_color
        
        // 
        let imageSize = CGSize(width: 150, height: 150)
        let image = drawCustomImage(imageSize, color: background_color)
        cell.busImage.image = image
        
        //
        
        // cell.busImage.image = UIImage(named: busImages)
        return cell
    }
    
    func drawCustomImage(size: CGSize, color: UIColor) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, color.CGColor)
        let rectangle = CGRectMake(0,0,150,150)
        CGContextAddRect(context, rectangle)
        CGContextFillPath(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let rowData = self.tableData[indexPath.row]
//        var route_short_name: NSString = rowData["route_short_name"] as! NSString
//        var route_id: NSString = rowData["route_id"] as! NSString
//        println("Hai premuto \(route_short_name) con route_id \(route_id)")
//        
//    }
    
    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    func list_of_bus(searchTerm: String) {
        
        let urlPath = "http://gtfs-provider.herokuapp.com\(searchTerm)"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? [Dictionary<String, String>] {
                
                let result = sorted(jsonResult) {
                    var o1 = $0["route_short_name"]!.toInt()
                    var o2 = $1["route_short_name"]!.toInt()
                    
                    if (o1 != nil){
                        if (o2 != nil){
                            return o1 < o2
                        }
                        return true
                    } else if (o2 != nil) {
                        return false
                    } else {
                        return $0["route_short_name"] < $1["route_short_name"]
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = result
                    self.tableView.reloadData()
                })
                
            } else {
                println("JSON Error \(err!.localizedDescription)")
            }
            
        })
        
        task.resume()
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

        if segue.identifier == "ShowBusDetail"{
            let detailBusController = segue.destinationViewController as! BusDetailTableViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow()
            let row = myIndexPath?.row
            let rowData = self.tableData[row!]
            var route_short_name: NSString = rowData["route_short_name"] as! NSString
            var route_id: NSString = rowData["route_id"] as! NSString
            var route_color: NSString = rowData["route_color"] as! NSString
            var route_long_name: NSString = rowData["route_long_name"] as! NSString
//            prepare_storage(route_id, route_short_name: route_short_name, route_color: route_color, route_long_name: route_long_name, direction: "0")

            detailBusController.route_id = route_id as String
            detailBusController.route_short_name = route_short_name as String
            detailBusController.route_long_name = route_long_name as String
            detailBusController.route_color = route_color as String
        }
    }
    
//    func prepare_storage(route_id: NSString, route_short_name: NSString, route_color: NSString, route_long_name: NSString, direction: NSString){
//        var dict: [String: NSString] = ["route_id": route_id, "route_short_name": route_short_name, "route_color": route_color, "route_long_name": route_long_name, "direction": "0", "stop_id" : "344"]
//        var to_append = true
//        for n in self.favorite{
//            if (n["route_short_name"] == dict["route_short_name"] && n["route_id"] == dict["route_id"]){
//                to_append = false
//                break
//            }
//        }
//        if (to_append == true ){
//            self.favorite.append(dict)
//        }
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(self.favorite, forKey: "obj")
//    }
    

}

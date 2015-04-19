//
//  EditFavoritesTableViewController.swift
//  Bus
//
//  Created by Davide Spadini on 18/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class EditFavoritesTableViewController: UITableViewController {
    var data_recv: [Dictionary<String, NSString>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editing = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj: NSArray = defaults.arrayForKey("obj"){
            self.data_recv = obj as! [Dictionary<String, NSString>]
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj: NSArray = defaults.arrayForKey("obj"){
            self.data_recv = obj as! [Dictionary<String, NSString>]
        }
        self.tableView.reloadData()
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
        return data_recv.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditFavoritesCell", forIndexPath: indexPath) as! EditFavoritesTableViewCell

        var row = indexPath.row
        var obj = self.data_recv[row]
        
        // Configure the cell...
        cell.longNameLabel.text = obj["route_long_name"]! as String
        cell.longNameLabel.font = UIFont.boldSystemFontOfSize(12)
        
        cell.shortNameLabel.font = UIFont.boldSystemFontOfSize(15)
        cell.shortNameLabel.textColor = UIColor.whiteColor()
        cell.shortNameLabel.text = obj["route_short_name"]! as String
        
        var background_color = UIColor.blackColor()
        var route_color = obj["route_color"]! as NSString
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
        cell.longNameLabel.textColor = background_color

        let imageSize = CGSize(width: 40, height: 40)
        let image = drawCustomImage(imageSize, color: background_color)
        cell.busImage.image = image
        
        
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete the row from the data source
            self.data_recv.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var itemToMove = self.data_recv[fromIndexPath.row]
        self.data_recv.removeAtIndex(fromIndexPath.row)
        self.data_recv.insert(itemToMove, atIndex: toIndexPath.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "DoneSegueButton" {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(self.data_recv, forKey: "obj")
        }
    }


}

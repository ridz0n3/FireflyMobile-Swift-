//
//  CustomFlightPickerViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 5/23/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class CustomFlightPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var destinationType = String()
    var picker = [String]()
    var selectPicker = Int()
    @IBOutlet weak var pickerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerTableView.layer.cornerRadius = 10
        pickerTableView.layer.borderColor = UIColor.orangeColor().CGColor
        pickerTableView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = NSIndexPath(forRow: selectPicker, inSection: 0)
        pickerTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picker.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.pickerTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.orangeColor()
        cell.selectedBackgroundView = bgColorView
        
        cell.textLabel?.text = picker[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        if destinationType == "departure"{
            NSNotificationCenter.defaultCenter().postNotificationName("departureSelected", object: nil, userInfo: ["index" : indexPath.row])
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("arrivalSelected", object: nil, userInfo: ["index" : indexPath.row])
        }
        
    }
    
    @IBAction func closedButtonPressed(sender: AnyObject) {
        
         self.dismissViewControllerAnimated(true, completion: nil)
        
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

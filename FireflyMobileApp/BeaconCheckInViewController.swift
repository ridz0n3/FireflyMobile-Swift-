//
//  BeaconCheckInViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/20/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class BeaconCheckInViewController: BaseViewController {

    @IBOutlet weak var closedBtn: UIButton!
    
    @IBOutlet weak var pnr: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var flightNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let itineraryData = defaults.objectForKey("itinerary") as! NSDictionary
        let flightDetail = itineraryData["flight_details"] as! NSArray
        let itineraryInformation = itineraryData["itinerary_information"] as! NSDictionary
        
        date.text = "\(flightDetail[0]["date"] as! String)"
        time.text = "\(flightDetail[0]["time"] as! String)"
        flightNo.text = "\(flightDetail[0]["flight_number"] as! String)"
        destination.text = "\(flightDetail[0]["station"] as! String)"
        pnr.text = "\(itineraryInformation["pnr"] as! String)"
        
        closedBtn.layer.cornerRadius = 10
        closedBtn.layer.borderWidth = 1
        closedBtn.layer.borderColor = UIColor.orangeColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closedBtnPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refreshDeparture", object: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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

//
//  SearchFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class SearchFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var hideRow : Bool = false
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var oneWayButton: UIButton!
    @IBOutlet weak var searchFlightTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        returnButton.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        oneWayButton.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if indexPath.row == 4 {
            return 80
        }else if indexPath.row == 3 && hideRow {
            return 0.0
        }else{
            return 50
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 4 {
            let cell = self.searchFlightTableView.dequeueReusableCellWithIdentifier("passengerCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
            return cell;
            
        }else{
            let cell = self.searchFlightTableView.dequeueReusableCellWithIdentifier("airportCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
            
            if indexPath.row == 0 {
                cell.iconImg.image = UIImage(named: "departure_icon")
                cell.airportLbl.text = "DEPARTURE AIRPORT"
            }else if indexPath.row == 1{
                cell.iconImg.image = UIImage(named: "arrival_icon")
                cell.airportLbl.text = "ARRIVAL AIRPORT"
                cell.lineStyle.image = UIImage(named: "lines")
            }else if indexPath.row == 2{
                cell.iconImg.image = UIImage(named: "date_icon")
                cell.airportLbl.text = "DEPARTURE DATE"
            }else{
                cell.iconImg.image = UIImage(named: "date_icon")
                cell.airportLbl.text = "RETURN DATE"
                cell.lineStyle.image = UIImage(named: "lines")
            }
            return cell;
        }

        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }

    func btnClick(sender : UIButton){
        
        let btnPress: UIButton = sender as UIButton
        
        if btnPress.tag == 1 {
            self.returnButton.backgroundColor = UIColor.whiteColor()
            self.oneWayButton.backgroundColor = UIColor.lightGrayColor()
            hideRow = false;
        }else{
            self.returnButton.backgroundColor = UIColor.lightGrayColor()
            self.oneWayButton.backgroundColor = UIColor.whiteColor()
            hideRow = true;
        }
        
        self.searchFlightTableView.beginUpdates()
        self.searchFlightTableView.endUpdates()
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
        let flightDetailVC = storyboard.instantiateViewControllerWithIdentifier("FlightDetailVC") as! FlightDetailViewController
        self.navigationController!.pushViewController(flightDetailVC, animated: true)
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

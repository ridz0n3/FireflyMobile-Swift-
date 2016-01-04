//
//  PaymentSummaryViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

class PaymentSummaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var paymentTableView: UITableView!
    var flightDetail = NSArray()
    var priceDetail = NSArray()
    var totalPrice = String()
    
    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBtn.layer.cornerRadius = 10
        
        setupLeftButton()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let paymentDetail = defaults.objectForKey("itenerary") as! NSDictionary
        flightDetail = paymentDetail["flight_details"] as! NSArray
        priceDetail = paymentDetail["price_details"] as! NSArray
        totalPrice = paymentDetail["total_price"] as! String
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return flightDetail.count
        }else{
            return priceDetail.count + 1
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 137
        }else{
            
            if (indexPath.row == 3 && flightDetail.count == 2) || (indexPath.row == 2 && flightDetail.count == 1){
                return 42
            }else{
                return 80
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.text = flightDetail[indexPath.row]["date"] as? String
            cell.destinationLbl.text = flightDetail[indexPath.row]["station"] as? String
            cell.flightNumberLbl.text = flightDetail[indexPath.row]["flight_number"] as? String
            cell.timeLbl.text = flightDetail[indexPath.row]["time"] as? String
            
            return cell
            
        }else{
            
            if (indexPath.row == 3 && flightDetail.count == 2) || (indexPath.row == 2 && flightDetail.count == 1){
                
                let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
                
                cell.totalPriceLbl.text = totalPrice
                
                return cell
                
            }else{
                let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
                
                let detail = priceDetail[indexPath.row] as! NSDictionary
                
                if detail["status"] as? String == "Services and Fees"{
                    
                    cell.flightDestination.text = detail["status"] as? String
                    cell.guestLbl.text = "Insurance"
                    cell.taxLbl.text = "Taxes"
                    
                    cell.guestPriceLbl.text = detail["services"]![0]["service_price"] as? String
                    cell.taxesPrice.text = detail["services"]![1]["service_price"] as? String
                    
                    cell.detailBtn.hidden = true
                    cell.detailLbl.hidden = true
                    
                }else{
                    
                    let tax = detail["taxes_or_fees"] as? NSDictionary
                    
                    let taxData = "Admin Fee : \(tax!["admin_fee"]!)\nAirport Tax: \(tax!["airport_tax"]!)\nFuel Surcharge : \(tax!["fuel_surcharge"]!)\nGood & Service Tax : \(tax!["goods_and_services_tax"]!)\nTotal : \(tax!["total"]!)"
                    
                    cell.flightDestination.text = detail["title"] as? String
                    cell.guestPriceLbl.text = detail["total_guest"] as? String
                    cell.guestLbl.text = detail["guest"] as? String
                    cell.taxesPrice.text = detail["total_taxes_or_fees"] as? String
                    
                    cell.detailBtn.addTarget(self, action: "detailBtnPressed:", forControlEvents: .TouchUpInside)
                    cell.detailBtn.accessibilityHint = taxData
                    cell.detailBtn.hidden = false
                    cell.detailLbl.hidden = false
                }
                return cell
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        if section == 0{
            sectionView.sectionLbl.text = "Flight Detail"
        }else{
            sectionView.sectionLbl.text = "Price Detail"
        }
        
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        self.showHud()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let signature = defaults.objectForKey("signature") as! String
        
        FireFlyProvider.request(.PaymentSelection(signature)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    self.hideHud()
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        self.showToastMessage(json["status"].string!)
                        let amountDue = json["amount_due"].int
                        let paymentChannel = json["payment_channel"].arrayObject
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
                        paymentVC.paymentType = paymentChannel!
                        paymentVC.totalDue = amountDue!
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
                    }else{
                        self.showToastMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                print (successResult.data)
            case .Failure(let failureResult):
                print (failureResult)
            }

        }
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        SCLAlertView().showSuccess("Taxes/Fee", subTitle: sender.accessibilityHint!)
        
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

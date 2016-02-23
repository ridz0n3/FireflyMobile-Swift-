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
    var flightDetail = [Dictionary<String,AnyObject>]()
    var priceDetail = [Dictionary<String,AnyObject>]()
    var serviceDetail = [Dictionary<String,AnyObject>]()
    var totalPrice = String()
    
    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBtn.layer.cornerRadius = 10
        
        setupLeftButton()
        
        let paymentDetail = defaults.objectForKey("itenerary") as! NSDictionary
        flightDetail = paymentDetail["flight_details"] as! [Dictionary<String,AnyObject>]
        priceDetail = paymentDetail["price_details"] as! [Dictionary<String,AnyObject>]
        totalPrice = paymentDetail["total_price"] as! String
        
        let service = priceDetail.last
        priceDetail.removeLast()// .removeLastObject()
        serviceDetail = service!["services"] as! [Dictionary<String,AnyObject>]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return flightDetail.count
        }else if section == 1{
            return priceDetail.count
        }else if section == 3{
            return serviceDetail.count
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 137
        }else if indexPath.section == 1{
            return 80
        }else if (indexPath.section == 2 && serviceDetail.count != 0) || indexPath.section == 3{
            return 23
        }else if indexPath.section == 4{
            return 42
        }else{
            return 0
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
            
        }else if indexPath.section == 1{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let tax = detail["taxes_or_fees"] as? NSDictionary
            
            let taxData = "Admin Fee : \(tax!["admin_fee"]!)\nAirport Tax: \(tax!["airport_tax"]!)\nFuel Surcharge : \(tax!["fuel_surcharge"]!)\nGood & Service Tax : \(tax!["goods_and_services_tax"]!)\nTotal : \(tax!["total"]!)"
            
            cell.flightDestination.text = detail["title"] as? String
            cell.guestPriceLbl.text = detail["total_guest"] as? String
            cell.guestLbl.text = detail["guest"] as? String
            cell.taxesPrice.text = detail["total_taxes_or_fees"] as? String
            
            cell.detailBtn.addTarget(self, action: "detailBtnPressed:", forControlEvents: .TouchUpInside)
            cell.detailBtn.accessibilityHint = taxData
            
            return cell
        }else if indexPath.section == 2{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("ServiceFeeCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            return cell
        }else if indexPath.section == 3{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("FeeCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            if serviceDetail.count != 0{
                cell.serviceLbl.text = serviceDetail[indexPath.row]["service_name"] as? String
                cell.servicePriceLbl.text = serviceDetail[indexPath.row]["service_price"] as? String
            }
            
            return cell
        }else{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.totalPriceLbl.text = totalPrice
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1{
            return 35
        }else{
            return 0
        }

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
        
        showHud("open")
        
        let signature = defaults.objectForKey("signature") as! String
        
        FireFlyProvider.request(.PaymentSelection(signature)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        let amountDue = json["amount_due"].int
                        let paymentChannel = json["payment_channel"].arrayObject
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! AddPaymentViewController
                        paymentVC.paymentType = paymentChannel!
                        paymentVC.totalDue = amountDue!
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
                    }else if json["status"] == "error"{
                        //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                showHud("close")
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        }
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        //SCLAlertView.showSuccess
        SCLAlertView().showSuccess("Taxes/Fee", subTitle: sender.accessibilityHint!, closeButtonTitle: "Close", colorStyle:0xEC581A)
        
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

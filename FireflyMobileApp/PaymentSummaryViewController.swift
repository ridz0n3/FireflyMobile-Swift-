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
        
        paymentTableView.estimatedRowHeight = 80
        paymentTableView.rowHeight = UITableViewAutomaticDimension
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.paymentSummaryScreen)

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
            return UITableViewAutomaticDimension
        }else if indexPath.section == 1{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            if let _ = detail["infant"] as? String{
                return 95
            }else{
                return 76
            }
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
            
            let str = "\(flightDetail[indexPath.row]["date"] as! String)\n\(flightDetail[indexPath.row]["station"] as! String)\n\(flightDetail[indexPath.row]["flight_number"] as! String)\n"
            
            let attrString = NSMutableAttributedString(string: str)
            if flightDetail[indexPath.row]["flight_note"] != nil{
                
                let myAttribute = [NSFontAttributeName: UIFont.italicSystemFontOfSize(14.0)]
                let myString = NSMutableAttributedString(string: "\(flightDetail[indexPath.row]["flight_note"] as! String)\n", attributes: myAttribute )
                attrString.appendAttributedString(myString)
                
            }
            
            attrString.appendAttributedString(NSAttributedString(string: flightDetail[indexPath.row]["time"] as! String))
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.attributedText = attrString
            
            return cell
            
        }else if indexPath.section == 1{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let tax = detail["taxes_or_fees"] as? NSDictionary
            var taxData = String()
            
            for (key, value) in tax! {
                 taxData += "\((key as! String).stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString): \(value as! String)\n"
            }
            
            if let infant = detail["infant"] as? String{
                cell.infantLbl.text = infant
                cell.infantPriceLbl.text = detail["total_infant"] as? String
            }else{
                cell.infantPriceLbl.hidden = true
                cell.infantLbl.hidden = true
            }
            
            cell.flightDestination.text = detail["title"] as? String
            cell.guestPriceLbl.text = detail["total_guest"] as? String
            cell.guestLbl.text = detail["guest"] as? String
            cell.taxesPrice.text = detail["total_taxes_or_fees"] as? String
            
            cell.detailBtn.addTarget(self, action: #selector(PaymentSummaryViewController.detailBtnPressed(_:)), forControlEvents: .TouchUpInside)
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
            sectionView.sectionLbl.text = "FLIGHT DETAILS"
        }else{
            sectionView.sectionLbl.text = "PRICE DETAILS"
        }
        
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        showLoading() 
        
        let signature = defaults.objectForKey("signature") as! String
        
        FireFlyProvider.request(.PaymentSelection(signature)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        let amountDue = json["amount_due"].doubleValue
                        let paymentChannel = json["payment_channel"].arrayObject
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! AddPaymentViewController
                        paymentVC.paymentType = paymentChannel!
                        paymentVC.totalDue = amountDue
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
                    }else if json["status"] == "error"{
                        
                        showErrorMessage(json["message"].string!)
                    }
                    hideLoading()
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        }
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        let newDetail = sender.accessibilityHint!.stringByReplacingOccurrencesOfString("And", withString: "&")
        SCLAlertView().showSuccess("Taxes/Fees", subTitle: newDetail, closeButtonTitle: "Close", colorStyle:0xEC581A)
        
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

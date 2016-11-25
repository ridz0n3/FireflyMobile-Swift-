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
        let flightType = defaults.object(forKey: "flightType") as! String
        AnalyticsManager.sharedInstance.logScreen("\(GAConstants.paymentSummaryScreen) (\(flightType))")

        continueBtn.layer.cornerRadius = 10
        
        setupLeftButton()
        
        let paymentDetail = defaults.object(forKey: "itenerary") as! NSDictionary
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.paymentTableView.dequeueReusableCell(withIdentifier: "FlightDetailCell", for: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let str = "\(flightDetail[indexPath.row]["date"] as! String)\n\(flightDetail[indexPath.row]["station"] as! String)\n\(flightDetail[indexPath.row]["flight_number"] as! String)\n"
            
            let attrString = NSMutableAttributedString(string: str)
            if flightDetail[indexPath.row]["flight_note"] != nil{
                
                let myAttribute = [NSFontAttributeName: UIFont.italicSystemFont(ofSize: 14.0)]
                let myString = NSMutableAttributedString(string: "\(flightDetail[indexPath.row]["flight_note"] as! String)\n", attributes: myAttribute )
                attrString.append(myString)
                
            }
            
            attrString.append(NSAttributedString(string: flightDetail[indexPath.row]["time"] as! String))
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.attributedText = attrString
            
            return cell
            
        }else if indexPath.section == 1{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            let cell = self.paymentTableView.dequeueReusableCell(withIdentifier: "PriceDetailCell", for: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let tax = detail["taxes_or_fees"] as? NSDictionary
            var taxData = String()
            
            for (key, value) in tax! {
                 taxData += "\((key as! String).replacingOccurrences(of: "_", with: " ").capitalized): \(value as! String)\n"
            }
            
            if let infant = detail["infant"] as? String{
                cell.infantLbl.text = infant
                cell.infantPriceLbl.text = detail["total_infant"] as? String
            }else{
                cell.infantPriceLbl.isHidden = true
                cell.infantLbl.isHidden = true
            }
            
            cell.flightDestination.text = detail["title"] as? String
            cell.guestPriceLbl.text = detail["total_guest"] as? String
            cell.guestLbl.text = detail["guest"] as? String
            cell.taxesPrice.text = detail["total_taxes_or_fees"] as? String
            
            cell.detailBtn.addTarget(self, action: #selector(PaymentSummaryViewController.detailBtnPressed(_:)), for: .touchUpInside)
            cell.detailBtn.accessibilityHint = taxData
            
            return cell
        }else if indexPath.section == 2{
            let cell = self.paymentTableView.dequeueReusableCell(withIdentifier: "ServiceFeeCell", for: indexPath) as! CustomPaymentSummaryTableViewCell
            
            return cell
        }else if indexPath.section == 3{
            let cell = self.paymentTableView.dequeueReusableCell(withIdentifier: "FeeCell", for: indexPath) as! CustomPaymentSummaryTableViewCell
            
            if serviceDetail.count != 0{
                cell.serviceLbl.text = serviceDetail[indexPath.row]["service_name"] as? String
                cell.servicePriceLbl.text = serviceDetail[indexPath.row]["service_price"] as? String
            }
            
            return cell
        }else{
            let cell = self.paymentTableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.totalPriceLbl.text = totalPrice
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1{
            return 35
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        if section == 0{
            sectionView.sectionLbl.text = "FLIGHT DETAILS"
        }else{
            sectionView.sectionLbl.text = "PRICE DETAILS"
        }
        
        
        sectionView.sectionLbl.textColor = UIColor.white
        sectionView.sectionLbl.textAlignment = NSTextAlignment.center
        
        return sectionView
        
    }
    
    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        
        showLoading() 
        
        let signature = defaults.object(forKey: "signature") as! String
        var personID = String()
        
        if try! LoginManager.sharedInstance.isLogin(){
            
            if (defaults.object(forKey: "personID") != nil){
                personID = defaults.object(forKey: "personID") as! String
            }
            
        }
        
        
        FireFlyProvider.request(.PaymentSelection(personID, signature)) { (result) -> () in
            
            switch result {
            case .success(let successResult):
                do {
                    
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        
                        let amountDue = json["amount_due"].doubleValue
                        let paymentChannel = json["payment_channel"].arrayObject
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentVC") as! AddPaymentViewController
                        paymentVC.paymentType = paymentChannel! as [AnyObject]
                        paymentVC.totalDue = amountDue
                        
                        if try! LoginManager.sharedInstance.isLogin(){
                            
                            if json["fop"] != nil{
                                paymentVC.cardInfo = json["fop"].dictionaryObject! as [String : AnyObject]
                            }else{
                                let cardInfo = ["card_type" : "",
                                                "account_number_id" : "",
                                                "card_holder_name" : "",
                                                "expiration_date_month" : "",
                                                "card_number" : "",
                                                "expiration_date_year" : ""]
                                paymentVC.cardInfo = cardInfo as [String : AnyObject]
                            }
                            
                        }else{
                            let cardInfo = ["card_type" : "",
                                        "account_number_id" : "",
                                        "card_holder_name" : "",
                                        "expiration_date_month" : "",
                                        "card_number" : "",
                                        "expiration_date_year" : ""]
                            paymentVC.cardInfo = cardInfo as [String : AnyObject]
                        }
                        
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
                    }else if json["status"] == "error"{
                        
                        showErrorMessage(json["message"].string!)
                    }else if json["status"].string == "401"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                        
                        for views in (self.navigationController?.viewControllers)!{
                            if views.classForCoder == HomeViewController.classForCoder(){
                                _ = self.navigationController?.popToViewController(views, animated: true)
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                            }
                        }
                    }
                    hideLoading()
                }
                catch {
                    
                }
                
            case .failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
            }
            
        }
        
    }
    
    func detailBtnPressed(_ sender:UIButton){
        
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 40,
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCircularIcon: true
        )
        let alertViewIcon = UIImage(named: "alertIcon")
        let newDetail = sender.accessibilityHint!.replacingOccurrences(of: "And", with: "&")//.stringByReplacingOccurrencesOfString("And", withString: "&")
        SCLAlertView(appearance:appearance).showSuccess("Taxes/Fees", subTitle: newDetail, closeButtonTitle: "Close", colorStyle:0xEC581A, circleIconImage: alertViewIcon)
        
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

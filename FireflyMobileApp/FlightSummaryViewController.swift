//
//  FlightSummaryViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/6/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData

class FlightSummaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var flightSummarryTableView: UITableView!
    var flightDetail = [Dictionary<String,AnyObject>]()
    var totalPrice = String()
    var insuranceDetails = NSDictionary()
    var contactInformation = NSDictionary()
    var itineraryInformation = NSDictionary()
    var paymentDetails = [Dictionary<String,AnyObject>]()
    var passengerInformation = [Dictionary<String,AnyObject>]()
    var totalDue = String()
    var totalPaid = String()
    var priceDetail = [Dictionary<String,AnyObject>]()
    var serviceDetail = [Dictionary<String,AnyObject>]()
    
    @IBOutlet weak var continueBtn: UIButton!
    var contacts = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.flightSummaryScreen)
        continueBtn.layer.cornerRadius = 10
        setupMenuButton()
        
        let itineraryData = defaults.objectForKey("itinerary") as! NSDictionary
        
        flightDetail = itineraryData["flight_details"] as! [Dictionary<String,AnyObject>]
        priceDetail = itineraryData["price_details"] as! [Dictionary<String,AnyObject>]
        totalPrice = itineraryData["total_price"] as! String
        insuranceDetails = itineraryData["insurance_details"] as! NSDictionary
        contactInformation = itineraryData["contact_information"] as! NSDictionary
        itineraryInformation = itineraryData["itinerary_information"] as! NSDictionary
        paymentDetails = itineraryData["payment_details"] as! [Dictionary<String,AnyObject>]
        passengerInformation = itineraryData["passenger_information"] as! [Dictionary<String,AnyObject>]
        totalDue = itineraryData["total_due"] as! String
        totalPaid = itineraryData["total_paid"] as! String
        
        let service = priceDetail.last
        priceDetail.removeLast()
        serviceDetail = service!["services"] as! [Dictionary<String,AnyObject>]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 1{
            return flightDetail.count
        }else if section == 2{
            return priceDetail.count
        }else if section == 4{
            return serviceDetail.count
        }else if section == 8{
            return passengerInformation.count
        }else if section == 9{
            return paymentDetails.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 170//83
        }else if indexPath.section == 1{
            return 137//167
        }else if indexPath.section == 2{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            if let _ = detail["infant"] as? String{
                return 95
            }else{
                return 76
            }
        }else if (indexPath.section == 3 && serviceDetail.count != 0) || indexPath.section == 4{
            return 29
        }else if indexPath.section == 5{
            return 42
        }else if (indexPath.section == 6 && insuranceDetails["status"] as! String != "N"){
            return 59
        }else if indexPath.section == 7{
            return 136
        }else if indexPath.section == 8{
            return 30
        }else if indexPath.section == 9{
            
            if indexPath.row == paymentDetails.count{
                return 80
            }else{
                return 42
            }
            
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("ItineraryCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.confirmationLbl.text = "\(itineraryInformation["pnr"]!)"
            cell.reservationLbl.text = "\(itineraryInformation["booking_status"]!)"
            cell.bookDateLbl.text = "Booking Date : \(itineraryInformation["booking_date"]!)"
            
            return cell
        }else if indexPath.section == 1{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.operatedMH.hidden = true
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.text = flightDetail[indexPath.row]["date"] as? String
            cell.destinationLbl.text = flightDetail[indexPath.row]["station"] as? String
            cell.flightNumberLbl.text = flightDetail[indexPath.row]["flight_number"] as? String
            cell.timeLbl.text = flightDetail[indexPath.row]["time"] as? String
            
            return cell
        }else if indexPath.section == 2{
            
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
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
            
            cell.detailBtn.addTarget(self, action: "detailBtnPressed:", forControlEvents: .TouchUpInside)
            cell.detailBtn.accessibilityHint = taxData
            
            return cell

        }else if indexPath.section == 3{
            let cell = self.flightSummarryTableView.dequeueReusableCellWithIdentifier("ServiceFeeCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            return cell
        }else if indexPath.section == 4{
            let cell = self.flightSummarryTableView.dequeueReusableCellWithIdentifier("FeeCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            if serviceDetail.count != 0{
                cell.serviceLbl.text = serviceDetail[indexPath.row]["service_name"] as? String
                cell.servicePriceLbl.text = serviceDetail[indexPath.row]["service_price"] as? String
            }
            
            return cell
        }else if indexPath.section == 5{
            let cell = self.flightSummarryTableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.totalPriceLbl.text = totalPrice
            
            return cell
        }else if indexPath.section == 6{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("InsuranceCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            if insuranceDetails["status"] as! String == "Y"{
                cell.confNumberLbl.text = "\(insuranceDetails["conf_number"]!)"
                cell.rateLbl.text = "\(insuranceDetails["rate"]!)"
            }
            
            return cell
        }else if indexPath.section == 7{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("ContactDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.contactNameLbl.text = "\(getTitleName(contactInformation["title"]! as! String)) \(contactInformation["first_name"]!) \(contactInformation["last_name"]!)"
            cell.contactEmail.text = "Email : \(contactInformation["email"]!)"
            cell.contactCountryLbl.text = "Country : \(contactInformation["country"]! as! String)"
            cell.contactMobileLbl.text = "Mobile Phone : \(contactInformation["mobile_phone"]!)"
            cell.contactAlternateLbl.text = "Alternate Phone : \(contactInformation["alternate_phone"]!)"
            
            return cell
        }else if indexPath.section == 8{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PassengerDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            let passengerDetail = passengerInformation[indexPath.row] as NSDictionary
            cell.passengerNameLbl.text = "\(passengerDetail["name"]!)"
            return cell
        }else {
            
            if indexPath.row == paymentDetails.count{
                let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PaymentDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
                cell.totalDueLbl.text = "Total Due : \(totalDue)"
                cell.totalPaidLbl.text = "Total Paid : \(totalPaid)"
                cell.paymentTotalPriceLbl.text = "Total Price : \(totalPrice)"
                return cell
            }else{
                let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("CardDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
                let cardData = paymentDetails[indexPath.row] as NSDictionary
                cell.cardPayLbl.text = "\(cardData["payment_amount"]!)"
                cell.cardStatusLbl.text = "\(cardData["payment_status"]!)"
                cell.cardTypeLbl.text = "\(cardData["payment_method"]!)"
                return cell
            }
            
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1 || section == 2 || (section == 6 && insuranceDetails["status"] as! String != "N") || section == 7 || section == 8 || section == 9{
            return 35
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        if section == 0{
            sectionView.sectionLbl.text = "ITINERARY INFORMATION"
        }else if section == 1{
            sectionView.sectionLbl.text = "FLIGHT DETAILS"
        }else if section == 2{
            sectionView.sectionLbl.text = "PRICE DETAILS"
        }else if section == 6{
            sectionView.sectionLbl.text = "INSURANCE DETAILS"
        }else if section == 7{
            sectionView.sectionLbl.text = "CONTACT INFORMATION"
        }else if section == 8{
            sectionView.sectionLbl.text = "PASSENGER INFORMATION"
        }else if section == 9{
            sectionView.sectionLbl.text = "PAYMENT DETAILS"
        }
        
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        SCLAlertView().showSuccess("Taxes/Fees", subTitle: sender.accessibilityHint!, closeButtonTitle: "Close", colorStyle:0xEC581A)
        
        
    }

    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        for views in (self.navigationController?.viewControllers)!{
            if views.classForCoder == HomeViewController.classForCoder(){
                self.navigationController?.popToViewController(views, animated: true)
                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
            }
        }
        
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

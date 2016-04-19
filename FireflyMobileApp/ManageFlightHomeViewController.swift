//
//  ManageFlightHomeViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData
import SwiftyJSON

class ManageFlightHomeViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sendItineraryBtn: UIButton!
    @IBOutlet weak var addPaymentBtn: UIButton!
    @IBOutlet weak var changeSeatBtn: UIButton!
    @IBOutlet weak var changePassangerBtn: UIButton!
    @IBOutlet weak var changeFlightBtn: UIButton!
    @IBOutlet weak var changeContactBtn: UIButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightSummarryTableView: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var ssrBtn: UIButton!
    
    var contacts = [NSManagedObject]()
    var totalDueStr = Double()
    var itineraryData = NSDictionary()
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
    var isConfirm = Bool()
    var pnr = String()
    var bookingId = String()
    var signature = String()
    var isLogin = Bool()
    var flightType = String()
    var userId = String()
    var ssr = [AnyObject]()
    var isAvailable = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightSummarryTableView.estimatedRowHeight = 80
        flightSummarryTableView.rowHeight = UITableViewAutomaticDimension
        
        AnalyticsManager.sharedInstance.logScreen(GAConstants.manageFlightHomeScreen)
        if isLogin{
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        
        if isConfirm{
            confirmView.hidden = false
            buttonView.hidden = true
            
            cancelBtn.layer.borderWidth = 0.5
            cancelBtn.layer.cornerRadius = 10.0
            
            confirmBtn.layer.borderWidth = 0.5
            confirmBtn.layer.cornerRadius = 10.0
            
            var newFrame = headerView.frame
            newFrame.size.height = 222
            headerView.frame = newFrame
            
            getInfo()
            
        }else{
            itineraryData = defaults.objectForKey("manageFlight") as! NSDictionary
            
            confirmView.hidden = true
            buttonView.hidden = false
            
            sendItineraryBtn.layer.borderWidth = 0.5
            sendItineraryBtn.layer.cornerRadius = 10.0
            
            changeContactBtn.layer.borderWidth = 0.5
            changeContactBtn.layer.cornerRadius = 10.0
            
            changeFlightBtn.layer.borderWidth = 0.5
            changeFlightBtn.layer.cornerRadius = 10.0
            
            changePassangerBtn.layer.borderWidth = 0.5
            changePassangerBtn.layer.cornerRadius = 10.0
            
            changeSeatBtn.layer.borderWidth = 0.5
            changeSeatBtn.layer.cornerRadius = 10.0
            
            addPaymentBtn.layer.borderWidth = 0.5
            addPaymentBtn.layer.cornerRadius = 10.0
            
            ssrBtn.layer.borderWidth = 0.5
            ssrBtn.layer.cornerRadius = 10.0
            
            getInfo()
            
            if totalDue == "0.00 MYR"{
                addPaymentBtn.hidden = true
                var newFrame = headerView.frame
                newFrame.size.height = newFrame.size.height - 42
                headerView.frame = newFrame
            }
            
            if flightType == "MH"{
                changeSeatBtn.hidden = true
                var newFrame = headerView.frame
                newFrame.size.height = newFrame.size.height - 42
                headerView.frame = newFrame
                
                if !isAvailable{
                    changeFlightBtn.hidden = true
                    ssrBtn.hidden = true
                    var newFrame = headerView.frame
                    newFrame.size.height = newFrame.size.height - 88
                    headerView.frame = newFrame
                    
                }
            }else{
                ssrBtn.hidden = true
                var newFrame = headerView.frame
                newFrame.size.height = newFrame.size.height - 42
                headerView.frame = newFrame
                
                if !isAvailable{
                    changeSeatBtn.hidden = true
                    changeFlightBtn.hidden = true
                    
                    var newFrame = headerView.frame
                    newFrame.size.height = newFrame.size.height - 88
                    headerView.frame = newFrame
                    
                }
            }
        }
        
        flightSummarryTableView.tableHeaderView = headerView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageFlightHomeViewController.refreshHomePage), name: "reloadHomePage", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func getInfo(){
        
        ssr = itineraryData["special_services_request"] as! [AnyObject]
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
        flightType = itineraryData["flight_type"] as! String
        let service = priceDetail.last
        priceDetail.removeLast()
        serviceDetail = service!["services"] as! [Dictionary<String,AnyObject>]
        
        for data in flightDetail{
            
            if data["flight_status"] as! String == "available"{
                isAvailable = true
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return flightDetail.count
        }else if section == 2{
            return priceDetail.count
        }else if section == 4{
            return serviceDetail.count
        }else if section == 7{
            let ssrPassenger = ssr[0]["passenger"] as! [AnyObject]
            return ssrPassenger.count + 1
        }else if (section == 8 && ssr.count == 2){
            let ssrPassenger = ssr[1]["passenger"] as! [AnyObject]
            return ssrPassenger.count + 1
        }else if section == 10{
            return passengerInformation.count
        }else if section == 11{
            return paymentDetails.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 1{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 2{
            let detail = priceDetail[indexPath.row] as NSDictionary
            
            if let _ = detail["infant"] as? String{
                return 95
            }else{
                return 76
            }
            
        }else if (indexPath.section == 3 && serviceDetail.count != 0){
            return 28
        }else if indexPath.section == 4{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 5{
            return 42
        }else if (indexPath.section == 6 && insuranceDetails["status"] as! String != "N"){
            return 59
        }else if indexPath.section == 7{
            return UITableViewAutomaticDimension
        }else if (indexPath.section == 8 && ssr.count == 2){
            return UITableViewAutomaticDimension
        }else if indexPath.section == 9{
            return 136
        }else if indexPath.section == 10{
            return 30
        }else if indexPath.section == 11{
            
            if indexPath.row == paymentDetails.count{
                return 80
            }else{
                return 26
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
            
            let str = "Booking Date : \(itineraryInformation["booking_date"]!)"
            
            let attrStr = NSMutableAttributedString(string: str)
            if itineraryInformation["itinerary_note"] != nil{
                
                let myAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0)]
                let myString = NSMutableAttributedString(string: "\n\n\(itineraryInformation["itinerary_note"]!)", attributes: myAttribute )
                attrStr.appendAttributedString(myString)
                
            }
            
            cell.bookDateLbl.attributedText = attrStr
            
            return cell
        }else if indexPath.section == 1{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
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
            
            cell.detailBtn.addTarget(self, action: #selector(ManageFlightHomeViewController.detailBtnPressed(_:)), forControlEvents: .TouchUpInside)
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
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("SSRCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let index = indexPath.row
            let ssrPassenger = ssr[0]
            
            if index == 0{
                cell.ssrPassengerName.text = ssrPassenger["type"] as? String
                cell.ssrPassengerName.font = UIFont.boldSystemFontOfSize(15.0)
            }else{
                let passengerInfo = ssrPassenger["passenger"] as! [AnyObject]
                
                var ssr = ""
                
                if passengerInfo[index - 1].count != 1{
                    
                    for ssrList in passengerInfo[index - 1]["list_ssr"] as! [AnyObject]{
                        ssr += "\(ssrList["ssr_name"] as! String)\n"
                    }
                    
                }
                let myAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0) ]
                let myString = NSMutableAttributedString(string: "Name :", attributes: myAttribute )
                let attrString = NSAttributedString(string: " \(passengerInfo[index - 1]["name"] as! String)\n\(ssr)")
                myString.appendAttributedString(attrString)
                
                cell.ssrPassengerName.attributedText = myString
            }
            
            return cell
        }else if (indexPath.section == 8 && ssr.count == 2){
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("SSRCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let index = indexPath.row
            let ssrPassenger = ssr[1]
            
            if index == 0{
                cell.ssrPassengerName.text = ssrPassenger["type"] as? String
                cell.ssrPassengerName.font = UIFont.boldSystemFontOfSize(15.0)
            }else{
                let passengerInfo = ssrPassenger["passenger"] as! [AnyObject]
                
                var ssr = ""
                
                if passengerInfo[index - 1].count != 1{
                    
                    for ssrList in passengerInfo[index - 1]["list_ssr"] as! [AnyObject]{
                        ssr += "\(ssrList["ssr_name"] as! String)\n"
                    }
                    
                }
                
                let myAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0) ]
                let myString = NSMutableAttributedString(string: "Name :", attributes: myAttribute )
                let attrString = NSAttributedString(string: " \(passengerInfo[index - 1]["name"] as! String)\n\(ssr)")
                myString.appendAttributedString(attrString)
                
                cell.ssrPassengerName.attributedText = myString

            }
            
            return cell
        }else if indexPath.section == 9{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("ContactDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.contactNameLbl.text = "\(getTitleName(contactInformation["title"]! as! String)) \(contactInformation["first_name"]!) \(contactInformation["last_name"]!)"
            cell.contactEmail.text = "Email : \(contactInformation["email"]!)"
            cell.contactCountryLbl.text = "Country : \(contactInformation["country"]! as! String)"
            cell.contactMobileLbl.text = "Mobile Phone : \(contactInformation["mobile_phone"]!)"
            cell.contactAlternateLbl.text = "Alternate Phone : \(contactInformation["alternate_phone"]!)"
            
            return cell
        }else if indexPath.section == 10{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PassengerDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            let passengerDetail = passengerInformation[indexPath.row] as NSDictionary
            
            if passengerDetail["type"] as! String == "Infant"{
                cell.passengerNameLbl.text = "\(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            }else{
                cell.passengerNameLbl.text = "\(getTitleName(passengerDetail["title"]! as! String)) \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            }
            
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
        
        if section == 0 || section == 1 || section == 2 || (section == 6 && insuranceDetails["status"] as! String != "N") || section == 7 || section == 9 || section == 10 || section == 11{
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
            sectionView.sectionLbl.text = "SPECIAL SERVICES REQUEST"
        }else if section == 9{
            sectionView.sectionLbl.text = "CONTACT INFORMATION"
        }else if section == 10{
            sectionView.sectionLbl.text = "PASSENGER INFORMATION"
        }else if section == 11{
            sectionView.sectionLbl.text = "PAYMENT DETAILS"
        }
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        SCLAlertView().showSuccess("Taxes/Fees", subTitle: sender.accessibilityHint!, closeButtonTitle: "Close", colorStyle:0xEC581A)
        
    }
    
    @IBAction func changeContactBtnPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
        let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageContactDetailVC") as! EditContactDetailViewController
        self.navigationController!.pushViewController(manageFlightVC, animated: true)
        
    }
    
    @IBAction func EditPassengerBtnPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
        let editPassengerVC = storyboard.instantiateViewControllerWithIdentifier("EditPassengerDetailVC") as! EditPassengerDetailViewController
        editPassengerVC.passengerInformation = passengerInformation
        editPassengerVC.pnr = itineraryInformation["pnr"] as! String
        editPassengerVC.bookingId = "\(itineraryData["booking_id"]!)"
        editPassengerVC.signature = itineraryData["signature"] as! String
        
        self.navigationController!.pushViewController(editPassengerVC, animated: true)
    }
    
    @IBAction func ChangeFlightBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading() 
        
        FireFlyProvider.request(.GetFlightAvailability(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let changeFlightVC = storyboard.instantiateViewControllerWithIdentifier("EditSearchFlightVC") as! EditSearchFlightViewController
                        changeFlightVC.flightDetail = json["journeys"].arrayObject!
                        changeFlightVC.pnr = self.pnr
                        changeFlightVC.bookId = "\(self.bookingId)"
                        changeFlightVC.signature = self.signature
                        self.navigationController!.pushViewController(changeFlightVC, animated: true)
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
    
    @IBAction func ChangeSeatBtnPressed(sender: AnyObject) {
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading() 
        
        FireFlyProvider.request(.GetAvailableSeat(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let changeSeatVC = storyboard.instantiateViewControllerWithIdentifier("EditSeatSelectionVC") as! EditSeatSelectionViewController
                        changeSeatVC.isEdit = true
                        changeSeatVC.pnr = self.pnr
                        changeSeatVC.seatFare = json["seat_fare"].arrayObject!
                        changeSeatVC.bookId = "\(self.bookingId)"
                        changeSeatVC.signature = self.signature
                        changeSeatVC.journeys = json["journeys"].arrayObject!
                        self.navigationController!.pushViewController(changeSeatVC, animated: true)
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
    
    @IBAction func AddPaymentBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading() 
        FireFlyProvider.request(.PaymentSelection(self.signature)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        self.totalDueStr = json["amount_due"].doubleValue
                        let paymentChannel = json["payment_channel"].arrayObject
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("EditPaymentVC") as! EditPaymentViewController
                        paymentVC.paymentType = paymentChannel!
                        paymentVC.totalDueStr = self.totalDueStr
                        paymentVC.bookingId = self.bookingId
                        paymentVC.signature = self.signature
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
    
    @IBAction func SendItineraryBtnPressed(sender: AnyObject) {
        
        //AnalyticsManager.sharedInstance.logScreen(GAConstants.sendItineraryScreen)
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading() 
        FireFlyProvider.request(.SendItinerary(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    hideLoading()
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        AnalyticsManager.sharedInstance.logScreen(GAConstants.sendItineraryScreen)
                        showToastMessage(json["message"].string!)
                        
                    }else if json["status"] == "error"{
                        
                        showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        }
        
    }
    
    @IBAction func confirmBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading() 
        FireFlyProvider.request(.ConfirmChange(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        if try LoginManager.sharedInstance.isLogin(){
                            self.sentData(self.signature, pnr: self.pnr, userName: defaults.objectForKey("userName") as! String, userId: defaults.objectForKey("userID") as! String)
                        }else{
                            self.sentData("", pnr: self.pnr, userName: defaults.objectForKey("userName") as! String, userId: "")
                        }
                        
                        
                    }else if json["status"] == "need_payment"{
                        
                        self.totalDueStr = json["total_due"].doubleValue
                        FireFlyProvider.request(.PaymentSelection(self.signature)) { (result) -> () in
                            
                            switch result {
                            case .Success(let successResult):
                                do {
                                    
                                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                    
                                    if json["status"] == "success"{
                                        
                                        let paymentChannel = json["payment_channel"].arrayObject
                                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("EditPaymentVC") as! EditPaymentViewController
                                        paymentVC.paymentType = paymentChannel!
                                        paymentVC.totalDueStr = self.totalDueStr
                                        paymentVC.bookingId = self.bookingId
                                        paymentVC.signature = self.signature
                                        self.navigationController!.pushViewController(paymentVC, animated: true)
                                        
                                    }else if json["status"] == "error"{
                                        
                                        showErrorMessage(json["message"].string!)
                                    }
                                    hideLoading()
                                }
                                catch {
                                    
                                }
                                
                            case .Failure(let failureResult):
                                
                                showErrorMessage(failureResult.nsError.localizedDescription)
                            }
                            
                        }
                        
                        
                    }else if json["status"] == "error"{
                        
                        hideLoading()
                        
                        showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        let navigationArray = self.navigationController?.viewControllers
        
        for subView in navigationArray!{
            
            if subView.classForCoder == ManageFlightHomeViewController.classForCoder(){
                self.navigationController?.popToViewController(subView , animated: true)
                NSNotificationCenter.defaultCenter().postNotificationName("reloadHomePage", object: nil)
                break
            }
            
        }
    }
    
    func refreshHomePage(){
        
        itineraryData = defaults.objectForKey("manageFlight") as! NSDictionary
        getInfo()
        flightSummarryTableView.reloadData()
        
    }
    
    func sentData(signature:String, pnr:String, userName:String, userId:String){
        
        FireFlyProvider.request(.RetrieveBooking(signature, pnr, userName, userId)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        defaults.setObject(json.object, forKey: "manageFlight")
                        defaults.synchronize()
                        
                        let navigationArray = self.navigationController?.viewControllers
                        
                        for subView in navigationArray!{
                            
                            if subView.classForCoder == ManageFlightHomeViewController.classForCoder(){
                                
                                hideLoading()
                                self.navigationController?.popToViewController(subView , animated: true)
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadHomePage", object: nil)
                                break
                            }
                            
                        }

                    }else if json["status"].string == "error"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                    }
                    
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        }

        
    }
    
    @IBAction func ssrBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showLoading()
        FireFlyProvider.request(.RetrieveSSRList(signature)) { (result) in
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let ssrVC = storyboard.instantiateViewControllerWithIdentifier("EditSSRVC") as! EditSSRViewController
                        ssrVC.pnr = self.pnr
                        ssrVC.bookingId = self.bookingId
                        ssrVC.signature = self.signature
                        ssrVC.meals = json["meal"].arrayObject!
                        self.navigationController!.pushViewController(ssrVC, animated: true)
                        hideLoading()
                    }else if json["status"].string == "error"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                    }
                    
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }

        }
        
    }
    
}

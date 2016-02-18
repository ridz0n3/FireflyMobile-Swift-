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
    
    var contacts = [NSManagedObject]()
    
    var itineraryData = NSDictionary()
    var flightDetail = NSArray()
    var totalPrice = String()
    var insuranceDetails = NSDictionary()
    var contactInformation = NSDictionary()
    var itineraryInformation = NSDictionary()
    var paymentDetails = NSArray()
    var passengerInformation = NSArray()
    var totalDue = String()
    var totalPaid = String()
    var priceDetail = NSMutableArray()
    var serviceDetail = NSArray()
    var isConfirm = Bool()
    var pnr = String()
    var bookingId = String()
    var signature = String()
    var isLogin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            getInfo()
            
            if totalDue == "0.00 MYR"{
                
                addPaymentBtn.highlighted = true
                addPaymentBtn.userInteractionEnabled = false
                
            }
        }
        
        flightSummarryTableView.tableHeaderView = headerView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshHomePage", name: "reloadHomePage", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func getInfo(){
    
        flightDetail = itineraryData["flight_details"] as! NSArray
        priceDetail = (itineraryData["price_details"]?.mutableCopy())! as! NSMutableArray
        totalPrice = itineraryData["total_price"] as! String
        insuranceDetails = itineraryData["insurance_details"] as! NSDictionary
        contactInformation = itineraryData["contact_information"] as! NSDictionary
        itineraryInformation = itineraryData["itinerary_information"] as! NSDictionary
        paymentDetails = itineraryData["payment_details"] as! NSArray
        passengerInformation = itineraryData["passenger_information"] as! NSArray
        totalDue = itineraryData["total_due"] as! String
        totalPaid = itineraryData["total_paid"] as! String
        
        let service = priceDetail.lastObject as! NSDictionary
        priceDetail.removeLastObject()
        serviceDetail = service["services"] as! NSArray
        
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
            return 83
        }else if indexPath.section == 1{
            return 137
        }else if indexPath.section == 2{
            return 80
        }else if (indexPath.section == 3 && serviceDetail.count != 0) || indexPath.section == 4{
            return 28
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
            cell.bookDateLbl.text = "Booking Date : \(itineraryInformation["booking_date"]!)"
            
            return cell
        }else if indexPath.section == 1{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.text = flightDetail[indexPath.row]["date"] as? String
            cell.destinationLbl.text = flightDetail[indexPath.row]["station"] as? String
            cell.flightNumberLbl.text = flightDetail[indexPath.row]["flight_number"] as? String
            cell.timeLbl.text = flightDetail[indexPath.row]["time"] as? String
            
            return cell
        }else if indexPath.section == 2{
            
            let detail = priceDetail[indexPath.row] as! NSDictionary
            
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            let tax = detail["taxes_or_fees"] as? NSDictionary
            
            let taxData = "Admin Fee : \(tax!["admin_fee"]!)\nAirport Tax: \(tax!["airport_tax"]!)\nFuel Surcharge : \(tax!["fuel_surcharge"]!)\nGood & Service Tax : \(tax!["goods_and_services_tax"]!)\nTotal : \(tax!["total"]!)"
            
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
            cell.contactCountryLbl.text = "Country : \(getCountryName(contactInformation["country"]! as! String))"
            cell.contactMobileLbl.text = "Mobile Phone : \(contactInformation["mobile_phone"]!)"
            cell.contactAlternateLbl.text = "Alternate Phone : \(contactInformation["alternate_phone"]!)"
            
            return cell
        }else if indexPath.section == 8{
            let cell = flightSummarryTableView.dequeueReusableCellWithIdentifier("PassengerDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            let passengerDetail = passengerInformation[indexPath.row] as! NSDictionary
            
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
                let cardData = paymentDetails[indexPath.row] as! NSDictionary
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
            sectionView.sectionLbl.text = "Itinerary Information"
        }else if section == 1{
            sectionView.sectionLbl.text = "Flight Details"
        }else if section == 2{
            sectionView.sectionLbl.text = "Price Details"
        }else if section == 6{
            sectionView.sectionLbl.text = "Insurance Details"
        }else if section == 7{
            sectionView.sectionLbl.text = "Contact Information"
        }else if section == 8{
            sectionView.sectionLbl.text = "Passenger Information"
        }else if section == 9{
            sectionView.sectionLbl.text = "Payment Details"
        }
        
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    func detailBtnPressed(sender:UIButton){
        
        SCLAlertView().showSuccess("Taxes/Fee", subTitle: sender.accessibilityHint!, closeButtonTitle: "Close", colorStyle:0xEC581A)
        
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
        
        showHud("open")
        
        FireFlyProvider.request(.GetFlightAvailability(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    
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
                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
            }
            
        }
        
    }
    
    @IBAction func ChangeSeatBtnPressed(sender: AnyObject) {
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showHud("open")
        
        FireFlyProvider.request(.GetAvailableSeat(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let changeSeatVC = storyboard.instantiateViewControllerWithIdentifier("EditSeatSelectionVC") as! EditSeatSelectionViewController
                        changeSeatVC.isEdit = true
                        changeSeatVC.pnr = self.pnr
                        changeSeatVC.bookId = "\(self.bookingId)"
                        changeSeatVC.signature = self.signature
                        changeSeatVC.journeys = json["journeys"].arrayObject!
                        self.navigationController!.pushViewController(changeSeatVC, animated: true)
                    }else if json["status"] == "error"{
                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
            }

        }
  
    }
    
    @IBAction func AddPaymentBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showHud("open")
        FireFlyProvider.request(.PaymentSelection(self.signature)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        let paymentChannel = json["payment_channel"].arrayObject
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("EditPaymentVC") as! EditPaymentViewController
                        paymentVC.paymentType = paymentChannel!
                        paymentVC.totalDueStr = self.totalDue
                        paymentVC.bookingId = self.bookingId
                        paymentVC.signature = self.signature
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
                    }else if json["status"] == "error"{
                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
            }
            
        }
        
    }
    
    @IBAction func SendItineraryBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showHud("open")
        FireFlyProvider.request(.SendItinerary(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let sendItineraryVC = storyboard.instantiateViewControllerWithIdentifier("SendItineraryVC") as! SendItineraryViewController
                        self.navigationController!.pushViewController(sendItineraryVC, animated: true)
                    }else if json["status"] == "error"{
                        showHud("close")
                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
            }

        }
        
    }
    
    @IBAction func confirmBtnPressed(sender: AnyObject) {
        
        pnr = itineraryInformation["pnr"] as! String
        bookingId = "\(itineraryData["booking_id"]!)"
        signature = itineraryData["signature"] as! String
        
        showHud("open")
        FireFlyProvider.request(.ConfirmChange(pnr, bookingId, signature)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        showHud("close")
                        
                        defaults.setObject(self.itineraryData, forKey: "manageFlight")
                        defaults.synchronize()
                        
                        let navigationArray = self.navigationController?.viewControllers
                        
                        for subView in navigationArray!{
                            
                            if subView.classForCoder == ManageFlightHomeViewController.classForCoder(){
                                self.navigationController?.popToViewController(subView , animated: true)
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadHomePage", object: nil)
                                break
                            }
                            
                        }
                        
                        //let vController = navigationArray![2]
                        
                    }else if json["status"] == "need_payment"{
                        
                        self.totalDue = json["total_due"].string!
                        FireFlyProvider.request(.PaymentSelection(self.signature)) { (result) -> () in
                            
                            switch result {
                            case .Success(let successResult):
                                do {
                                    showHud("close")
                                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                    
                                    if json["status"] == "success"{
                                        
                                        let paymentChannel = json["payment_channel"].arrayObject
                                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("EditPaymentVC") as! EditPaymentViewController
                                        paymentVC.paymentType = paymentChannel!
                                        paymentVC.totalDueStr = self.totalDue
                                        paymentVC.bookingId = self.bookingId
                                        paymentVC.signature = self.signature
                                        self.navigationController!.pushViewController(paymentVC, animated: true)
                                        
                                    }else if json["status"] == "error"{
                                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                                    }
                                }
                                catch {
                                    
                                }
                                
                            case .Failure(let failureResult):
                                print (failureResult)
                            }
                            
                        }
                        
                        
                    }else if json["status"] == "error"{
                        showHud("close")
                        //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
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
    
    
}

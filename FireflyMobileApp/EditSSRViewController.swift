//
//  EditSSRViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 4/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class EditSSRViewController: BaseXLFormViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var pnr = String()
    var bookingId = String()
    var signature = String()
    var meals = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        setupLeftButton()
        continueBtn.layer.cornerRadius = 10
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        var i = 0
        for mealInfo in meals{
            
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle(mealInfo["destination_name"] as? String)
            form.addFormSection(section)
            
            let passengerList = mealInfo["passenger"] as! [AnyObject]
            
            for passengerInfo in passengerList{
                
                // Meals
                row = XLFormRowDescriptor(tag: "\(Tags.ValidationSSRList)(\(i)\(passengerInfo["passenger_number"] as! String))", rowType:XLFormRowDescriptorTypeFloatLabeled, title:passengerInfo["name"] as? String)
                
                if mealInfo["flight_status"] as! String != "departed"{
                    let mealList = mealInfo["list_meal"] as! [AnyObject]
                    var tempArray:[AnyObject] = [AnyObject]()
                    for mealsDetail in mealList{
                        tempArray.append(XLFormOptionsObject(value: mealsDetail["meal_code"], displayText: mealsDetail["name"] as! String))
                        
                        if mealsDetail["meal_code"] as! String == nilIfEmpty(passengerInfo["meal_code"]) as! String{
                            row.value = mealsDetail["name"] as! String
                        }
                    }
                    
                    row.selectorOptions = tempArray
                    
                }else{
                    
                    row.value = passengerInfo["meal_name"] as! String
                    row.disabled = true
                }
                section.addFormRow(row)
                
            }
            i += 1
        }
        
        self.form = form
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        let index = UInt(section)
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        sectionView.views.backgroundColor = UIColor.whiteColor()
        sectionView.sectionLbl.textColor = UIColor.blackColor()
        sectionView.sectionLbl.font = UIFont.boldSystemFontOfSize(12.0)
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Left
        
        return sectionView
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        let goingSSRDict = NSMutableArray()
        let returnSSRDict = NSMutableArray()
        var departCount = 0
        
        var i = 0
        for ssrInfo in meals{
            
            if ssrInfo["flight_status"] as! String != "departed"{
                
                let mealList = ssrInfo["list_meal"] as! [AnyObject]
                let passengerList = ssrInfo["passenger"] as! [AnyObject]
                var tempDict = [AnyObject]()
                
                for passengerInfo in passengerList{
                    
                    let passengerDict = NSMutableDictionary()
                    for mealsInfo in mealList{
                        
                        if formValues()["\(Tags.ValidationSSRList)(\(i)\(passengerInfo["passenger_number"] as! String))"] as! String == mealsInfo["name"] as! String{
                            
                            passengerDict.setValue("\(passengerInfo["passenger_number"] as! String)", forKey: "passenger_number")
                            passengerDict.setValue(mealsInfo["meal_code"] as! String, forKey: "meal_code")
                            break
                            
                        }
                        
                    }
                    
                    tempDict.append(passengerDict)
                }
                
                if i == 0{
                    goingSSRDict.addObject(tempDict)
                }else{
                    returnSSRDict.addObject(tempDict)
                }
            }else{
                departCount += 1
            }
            
            i += 1
            
        }
        
        
        if departCount == meals.count{
            showErrorMessage("Departed flight cannot be changed.")
        }else
        if departCount == 0{
            
            if meals.count == 1{
                
                oneSSR("going_flight", detail: goingSSRDict[0])
                
            }else{
                
                twoSSR(goingSSRDict[0], returnSSR: returnSSRDict[0])
            }
            
        }else{
            
            var type = String()
            var detailSSR = [AnyObject]()
            
            if goingSSRDict.count != 0{
                
                type = "going_flight"
                detailSSR = goingSSRDict as [AnyObject]
                
            }else
            if returnSSRDict.count != 0{
                
                type = "return_flight"
                detailSSR = returnSSRDict as [AnyObject]
                
            }
            
            oneSSR(type, detail: detailSSR[0])
        }
        
    }
    
    func twoSSR(goingSSR : AnyObject, returnSSR : AnyObject){
        
        showLoading()
        FireFlyProvider.request(.ChangeSSR2Way(pnr, bookingId, signature, goingSSR, returnSSR)) { (result) in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                        manageFlightVC.isConfirm = true
                        manageFlightVC.itineraryData = json.object as! NSDictionary
                        self.navigationController!.pushViewController(manageFlightVC, animated: true)
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
    
    func oneSSR(type : String, detail : AnyObject){
        
        showLoading()
        FireFlyProvider.request(.ChangeSSR(pnr, bookingId, signature, type, detail)) { (result) in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                        manageFlightVC.isConfirm = true
                        manageFlightVC.itineraryData = json.object as! NSDictionary
                        self.navigationController!.pushViewController(manageFlightVC, animated: true)
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

//
//  MobileCheckInDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/3/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import M13Checkbox
class MobileCheckInDetailViewController: BaseXLFormViewController {

    var checkInDetail = NSDictionary()
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var seatNo: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var passengerName: UIView!
    @IBOutlet weak var flightDate: UILabel!
    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var stationCode: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var checkStatus: UILabel!

    var arr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        continueBtn.layer.cornerRadius = 10
        
        let flightDetail = checkInDetail["flight_detail"] as! NSDictionary
        stationCode.text = "\(flightDetail["station_code"] as! String)"
        flightDate.text = "\(flightDetail["flight_date"] as! String)"
        flightNumber.text = "\(flightDetail["flight_number"] as! String)"
        time.text = "\(flightDetail["departure_time"] as! String)"
        // Do any additional setup after loading the view.
        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        var i = 0
        
        for passengerData in checkInDetail["passengers"] as! NSArray {
            section = XLFormSectionDescriptor()
            //section = XLFormSectionDescriptor.formSectionWithTitle("Adult \(i)")
            form.addFormSection(section)
            arr.append("false")
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, i), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            var tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
                
                if passengerData["travel_document"] as? String == travel["doc_code"]{
                    row.value = travel["doc_name"]
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, i), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Issuing Country:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                
                if passengerData["issuing_country"] as? String == country["country_code"] as? String{
                    row.value = country["country_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, i), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            row.value = passengerData["document_number"] as! String
            section.addFormRow(row)
            
            // Enrich Loyalty No
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, i), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"BonusLink Card No:")
            //row.value = adultDetails[i]["enrich_loyalty_number"] as! String
            section.addFormRow(row)
            
            i++
        }
        
        self.form = form
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if arr[indexPath.section] == "true"{
            return 48
        }else{
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        passengerName = NSBundle.mainBundle().loadNibNamed("MobileCheckInView", owner: self, options: nil)[0] as! UIView
        
        let passengerData = checkInDetail["passengers"]![section] as! NSDictionary
        name.text = "\(getTitleName(passengerData["title"] as! String)) \(passengerData["first_name"] as! String) \(passengerData["last_name"] as! String)"
        seatNo.text = passengerData["seat"]! as? String
        checkBtn.tag = section
        
        checkBtn.addTarget(self, action: "check:", forControlEvents: .TouchUpInside)
        
        if passengerData["status"] as! String == "Checked In"{
            checkBox.hidden = true
            checkStatus.hidden = false
            checkBtn.hidden = true
        }else{
            checkBox.hidden = false
            checkStatus.hidden = true
            checkBtn.hidden = false
        }
        
        if arr[section] == "true"{
            checkBox.checkState = M13CheckboxStateChecked
        }else{
            checkBox.checkState = M13CheckboxStateUnchecked
        }
        
        return passengerName
        
    }
    
    func check(sender : UIButton){
        var i = 0
        
        for arrData in arr{
            
            if i == sender.tag{
                
                if arrData == "true"{
                    arr.removeAtIndex(i)
                    arr.insert("false", atIndex: i)
                }else{
                    arr.removeAtIndex(i)
                    arr.insert("true", atIndex: i)
                }
                
            }
            i++
            
        }
        detailTableView.beginUpdates()
        detailTableView.endUpdates()
        detailTableView.reloadData()
        //checkBox.checkState = M13CheckboxStateChecked
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        var checkData = 0
        for arrData in arr{
            if arrData == "true"{
                checkData++
            }
        }
        
        if checkData == 0{
            showToastMessage("No passenger selected.")
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

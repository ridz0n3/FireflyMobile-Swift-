//
//  CommonAddAdultViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/7/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import RealmSwift

class CommonAdultViewController: BaseXLFormViewController {

    var action = String()
    var adultInfo = NSDictionary()
    var familyAndFriendInfo = FamilyAndFriendData()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        if action == "add"{
            let adultTempData = ["id" : 0,
                                 "title" : "",
                                 "first_name" : "",
                                 "last_name" : "",
                                 "dob" : "",
                                 "nationality" : "",
                                 "bonuslink_card" : "",
                                 "type" : "Adult"]
            adultInfo = adultTempData as NSDictionary
        }else{
            let adultTempData = ["id" : familyAndFriendInfo.id,
                    "title" : familyAndFriendInfo.title,
                    "gender" : familyAndFriendInfo.gender,
                    "first_name" : familyAndFriendInfo.firstName,
                    "last_name" : familyAndFriendInfo.lastName,
                    "dob" : familyAndFriendInfo.dob,
                    "nationality" : familyAndFriendInfo.country,
                    "bonuslink_card" : familyAndFriendInfo.bonuslink,
                    "type" : familyAndFriendInfo.type]
            adultInfo = adultTempData as NSDictionary
        }
        initialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            
            if title["title_code"] as! String == adultInfo["title"] as! String{
                row.value = title["title_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        row.value = adultInfo["first_name"] as! String
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = adultInfo["last_name"] as! String
        row.required = true
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.required = true
        if adultInfo["dob"] as! String != ""{
            row.value = formatDate(stringToDate(adultInfo["dob"] as! String))
        }
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if country["country_code"] as! String == adultInfo["nationality"] as! String{
                row.value = country["country_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Enrich Loyalty No
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
        //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
        row.value = adultInfo["bonuslink_card"]! as! String
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    func saveFamilyAndFriend(familyAndFriendInfo : [AnyObject]){
        
        let userInfo = defaults.objectForKey("userInfo")
        var userList = Results<FamilyAndFriendList>!()
        userList = realm.objects(FamilyAndFriendList)
        let mainUser = userList.filter("email == %@",userInfo!["username"] as! String)
        
        if mainUser.count != 0{
            if mainUser[0].familyList.count != 0{
                realm.beginWrite()
                realm.delete(mainUser[0].familyList)
                try! realm.commitWrite()
            }
        }
        
        for list in familyAndFriendInfo{
            
            let data = FamilyAndFriendData()
            data.id = list["id"] as! Int
            data.title = list["title"] as! String
            data.gender = nullIfEmpty(list["gender"]) as! String
            data.firstName = list["first_name"] as! String
            data.lastName = list["last_name"] as! String
            //let dateArr = (list["dob"] as! String).componentsSeparatedByString("-")
            data.dob = list["dob"] as! String//"\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            data.country = list["nationality"] as! String
            data.bonuslink = list["bonuslink_card"] as! String
            data.type = list["type"] as! String
            
            if mainUser.count == 0{
                let user = FamilyAndFriendList()
                user.email = userInfo!["username"] as! String
                user.familyList.append(data)
                
                try! realm.write({ () -> Void in
                    realm.add(user)
                })
                
            }else{
                
                try! realm.write({ () -> Void in
                    mainUser[0].familyList.append(data)
                    mainUser[0].email = userInfo!["username"] as! String
                })
                
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

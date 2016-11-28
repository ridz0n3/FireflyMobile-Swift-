//
//  CommonInfantViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/13/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import RealmSwift

class CommonInfantViewController: BaseXLFormViewController {

    var action = String()
    var infantInfo = NSDictionary()
    var familyAndFriendInfo = FamilyAndFriendData()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        if action == "add"{
            let infantTempData = ["id" : 0,
                                  "gender" : "",
                                  "first_name" : "",
                                  "last_name" : "",
                                  "dob" : "",
                                  "nationality" : "",
                                  "type" : "Infant"] as [String : Any]
            infantInfo = infantTempData as NSDictionary
        }else{
            let infantTempData = ["id" : familyAndFriendInfo.id,
                                 "title" : familyAndFriendInfo.title,
                                 "gender" : familyAndFriendInfo.gender,
                                 "first_name" : familyAndFriendInfo.firstName,
                                 "last_name" : familyAndFriendInfo.lastName,
                                 "dob" : familyAndFriendInfo.dob,
                                 "nationality" : familyAndFriendInfo.country,
                                 "bonuslink_card" : familyAndFriendInfo.bonuslink,
                                 "type" : familyAndFriendInfo.type] as [String : Any]
            infantInfo = infantTempData as NSDictionary
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
        
        // Gender
        row = XLFormRowDescriptor(tag: Tags.ValidationGender, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Gender:*")
        
        var tempArray = [AnyObject]()
        for gender in genderArray{
            tempArray.append(XLFormOptionsObject(value: gender["gender_code"]!, displayText: gender["gender_name"]!))
            if gender["gender_code"]! == infantInfo["gender"] as! String{
                row.value = gender["gender_name"]!
            }
            
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = infantInfo["first_name"] as! String
        row.isRequired = true
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = infantInfo["last_name"] as! String
        row.isRequired = true
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.isRequired = true
        if infantInfo["dob"] as! String != ""{
            row.value = formatDate(stringToDate(infantInfo["dob"] as! String))
        }else{
            row.value = ""
        }
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if country["country_code"] as! String == infantInfo["nationality"] as! String{
                row.value = country["country_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    func saveFamilyAndFriend(_ familyAndFriendInfo : [AnyObject]){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userList = Results<FamilyAndFriendList>!()
        let userList = realm.objects(FamilyAndFriendList.self)
        let mainUser = userList.filter("email == %@", "\(userInfo["username"] as! String)")
        
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
            data.title = nullIfEmpty(list["title"] as AnyObject)
            data.gender = nullIfEmpty(list["gender"] as AnyObject)
            data.firstName = list["first_name"] as! String
            data.lastName = list["last_name"] as! String
            //let dateArr = (list["dob"] as! String).components(separatedBy: "-")
            data.dob = list["dob"] as! String//"\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            data.country = list["nationality"] as! String
            data.bonuslink = nullIfEmpty(list["bonuslink_card"] as AnyObject)
            data.type = list["type"] as! String
            
            if mainUser.count == 0{
                let user = FamilyAndFriendList()
                user.email = userInfo["username"] as! String
                user.familyList.append(data)
                
                try! realm.write({ () -> Void in
                    realm.add(user)
                })
                
            }else{
                
                try! realm.write({ () -> Void in
                    mainUser[0].familyList.append(data)
                    mainUser[0].email = userInfo["username"] as! String
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

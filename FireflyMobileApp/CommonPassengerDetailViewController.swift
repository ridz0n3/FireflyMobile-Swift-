//
//  CommonPassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import ActionSheetPicker_3_0
import RealmSwift

class CommonPassengerDetailViewController: BaseXLFormViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var userInfo = NSDictionary()
    var adultList = [AnyObject]()
    var infantList = [AnyObject]()
    var adultName = [String]()
    var infantName = [String]()
    var module = String()
    var adultCount = Int()
    var infantCount = Int()
    var adultArray = [Dictionary<String,AnyObject>]()
    var flightType = String()
    var adultDetails = [Dictionary<String,AnyObject>]()
    var infantDetails = [Dictionary<String,AnyObject>]()
    var familyAndFriend = [AnyObject]()
    var adultInfo = [String : AnyObject]()
    var infantInfo = [String : AnyObject]()
    var data = [String : AnyObject]()
    var familyAndFriendList : List<FamilyAndFriendData>! = nil
    var saveFamilyAndFriend = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        setupLeftButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommonPassengerDetailViewController.addExpiredDate(_:)), name: NSNotification.Name(rawValue: "expiredDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommonPassengerDetailViewController.removeExpiredDate(_:)), name: NSNotification.Name(rawValue: "removeExpiredDate"), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
            
            if section == 0{
                return 91
            }else{
                
                if section <= adultCount{
                    if adultList.count == 0{
                        return 35
                    }else{
                        return 91
                    }
                }else{
                    if infantList.count == 0{
                        return 35
                    }else{
                        return 91
                    }
                }
                
            }
            
        }else{
            return 35
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
            let index = UInt(section)
            
            if index == 0{
                let sectionView = Bundle.main.loadNibNamed("PassengerHeaderView", owner: self, options: nil)?[0] as! PassengerHeaderViewButton
                
                sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                sectionView.familyButton.layer.borderWidth = 1
                sectionView.familyButton.layer.borderColor = UIColor.orange.cgColor
                sectionView.familyButton.setTitle("Manage Family & Friends", for: .normal)
                sectionView.familyButton.addTarget(self, action: #selector(CommonPassengerDetailViewController.manageButtonClicked), for: .touchUpInside)
                sectionView.titleLbl.text = form.formSection(at: index)?.title
                sectionView.titleLbl.textColor = UIColor.white
                sectionView.titleLbl.textAlignment = NSTextAlignment.center
                sectionView.familyButton.layer.cornerRadius = 10
                sectionView.familyButton.tag = section
                
                return sectionView
            }else{
                
                if section <= adultCount{
                    if adultList.count == 0{
                        let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
                        
                        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                        
                        let index = UInt(section)
                        
                        sectionView.sectionLbl.text = form.formSection(at: index)?.title
                        sectionView.sectionLbl.textColor = UIColor.white
                        sectionView.sectionLbl.textAlignment = NSTextAlignment.center
                        
                        return sectionView
                    }else{
                        let sectionView = Bundle.main.loadNibNamed("PassengerHeaderView", owner: self, options: nil)?[0] as! PassengerHeaderViewButton
                        
                        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                        sectionView.familyButton.addTarget(self, action: #selector(CommonPassengerDetailViewController.selectButtonClicked(_:)), for: .touchUpInside)
                        sectionView.familyButton.accessibilityHint = form.formSection(at: index)?.title
                        sectionView.familyButton.layer.borderWidth = 1
                        sectionView.familyButton.layer.borderColor = UIColor.orange.cgColor
                        sectionView.titleLbl.text = form.formSection(at: index)?.title
                        sectionView.titleLbl.textColor = UIColor.white
                        sectionView.titleLbl.textAlignment = NSTextAlignment.center
                        sectionView.familyButton.layer.cornerRadius = 10
                        sectionView.familyButton.tag = section
                        
                        return sectionView
                    }
                }else{
                    
                    if infantList.count == 0{
                        let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
                        
                        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                        
                        let index = UInt(section)
                        
                        sectionView.sectionLbl.text = form.formSection(at: index)?.title
                        sectionView.sectionLbl.textColor = UIColor.white
                        sectionView.sectionLbl.textAlignment = NSTextAlignment.center
                        
                        return sectionView
                    }else{
                        let sectionView = Bundle.main.loadNibNamed("PassengerHeaderView", owner: self, options: nil)?[0] as! PassengerHeaderViewButton
                        
                        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                        sectionView.familyButton.addTarget(self, action: #selector(CommonPassengerDetailViewController.selectButtonClicked(_:)), for: .touchUpInside)
                        sectionView.familyButton.accessibilityHint = form.formSection(at: index)?.title
                        sectionView.familyButton.layer.borderWidth = 1
                        sectionView.familyButton.layer.borderColor = UIColor.orange.cgColor
                        sectionView.titleLbl.text = form.formSection(at: index)?.title
                        sectionView.titleLbl.textColor = UIColor.white
                        sectionView.titleLbl.textAlignment = NSTextAlignment.center
                        sectionView.familyButton.layer.cornerRadius = 10
                        let type = (form.formSection(at: index)?.title)!.components(separatedBy: " ")
                        sectionView.familyButton.tag = Int(type[1])!
                        
                        return sectionView
                    }
                    
                }
            }
            
        }else{
            let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
            
            sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            
            let index = UInt(section)
            
            sectionView.sectionLbl.text = form.formSection(at: index)?.title
            sectionView.sectionLbl.textColor = UIColor.white
            sectionView.sectionLbl.textAlignment = NSTextAlignment.center
            
            return sectionView
        }
        
    }
    
    func getFormData()->([AnyObject], [AnyObject], String, String, Bool, Bool){
        var passenger = [String:AnyObject]()
        var passengerName = [String]()
        
        var tempPassenger = [AnyObject]()
        
        for i in 0..<adultCount{
            var count = i
            count = count + 1
            var saveAdultInfo = [String:AnyObject]()
            
            let name = "\(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String, titleArr: titleArray) \(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]!) \(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]!))"
            passengerName.append(name)
            
            saveAdultInfo.updateValue(getTitleCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String, titleArr: titleArray) as AnyObject, forKey: "title")
            saveAdultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]! as AnyObject, forKey: "first_name")
            saveAdultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]! as AnyObject, forKey: "last_name")
            
            let date = formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as! String
            var arrangeDate = date.components(separatedBy: "-")
            
            saveAdultInfo.updateValue("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])" as AnyObject, forKey: "dob")
            saveAdultInfo.updateValue(date as AnyObject, forKey: "dob2")
            //adultInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            saveAdultInfo.updateValue("NRIC" as AnyObject, forKey: "travel_document")
            saveAdultInfo.updateValue(getCountryCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray) as AnyObject, forKey: "issuing_country")
            //adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDocumentNo, count)]!.xmlSimpleEscapeString(), forKey: "document_number")
            saveAdultInfo.updateValue("" as AnyObject, forKey: "document_number")
            
            let expiredDate = nilIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationExpiredDate, count)] as AnyObject)
            var arrangeExpDate = [String]()
            var newExpDate = String()
            
            if expiredDate != ""{
                arrangeExpDate = expiredDate.components(separatedBy: "-")//.components(separatedBy: "-")
                newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
            }
            
            saveAdultInfo.updateValue(newExpDate as AnyObject, forKey: "expiration_date")
            
            if flightType == "FY"{
                saveAdultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)] as AnyObject) as AnyObject, forKey: "bonuslink")
            }
            
            if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                let status = formValues()[String(format: "%@(adult%i)", Tags.SaveFamilyAndFriend, count)] as! NSDictionary
                saveAdultInfo.updateValue((formValues()[String(format: "%@(adult%i)", Tags.SaveFamilyAndFriend, count)] as AnyObject)["status"] as! Bool as AnyObject, forKey: "Save")
                if status["status"] as! Bool == false{
                    saveAdultInfo.updateValue("N" as AnyObject, forKey: "friend_and_family")
                }else{
                    saveAdultInfo.updateValue("Y" as AnyObject, forKey: "friend_and_family")
                    saveAdultInfo.updateValue("Adult" as AnyObject, forKey: "passenger_type")
                    let passengerId = adultInfo["\(i)"] as! NSDictionary
                    
                    if (passengerId["id"] != nil && (passengerId["id"] as AnyObject).classForCoder != NSString.classForCoder()){
                        saveAdultInfo.updateValue(passengerId["id"] as! Int as AnyObject, forKey: "friend_and_family_id")
                    }
                    
                }
            }
            
            passenger.updateValue(saveAdultInfo as AnyObject, forKey: "\(i)")
            adultInfo.updateValue(saveAdultInfo as AnyObject, forKey: "\(i)")
            tempPassenger.append(saveAdultInfo as AnyObject)
        }
        
        var travelWith = [String]()
        var infant = [String:AnyObject]()
        var tempInfant = [AnyObject]()
        
        for j in 0..<infantCount{
            var count = j
            count = count + 1
            var saveInfantInfo = [String:AnyObject]()
            
            travelWith.append(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray))
            
            saveInfantInfo.updateValue(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray) as AnyObject, forKey: "traveling_with")
            saveInfantInfo.updateValue(getGenderCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationGender, count)] as! String, genderArr: genderArray as [Dictionary<String, AnyObject>]) as AnyObject, forKey: "gender")
            saveInfantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationFirstName, count)]! as AnyObject, forKey: "first_name")
            saveInfantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationLastName, count)]! as AnyObject, forKey: "last_name")
            
            let date = formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String
            let arrangeDate = date.components(separatedBy: "-")
            
            saveInfantInfo.updateValue("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])" as AnyObject, forKey: "dob")
            saveInfantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String as AnyObject, forKey: "dob2")
            //infantInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            saveInfantInfo.updateValue("NRIC" as AnyObject, forKey: "travel_document")
            saveInfantInfo.updateValue(getCountryCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray) as AnyObject, forKey: "issuing_country")
            //infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDocumentNo, count)]!.xmlSimpleEscapeString(), forKey: "document_number")
            saveInfantInfo.updateValue("" as AnyObject, forKey: "document_number")
            
            if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                let status = formValues()[String(format: "%@(infant%i)", Tags.SaveFamilyAndFriend, count)] as! NSDictionary
                saveInfantInfo.updateValue((formValues()[String(format: "%@(infant%i)", Tags.SaveFamilyAndFriend, count)] as AnyObject)["status"] as! Bool as AnyObject, forKey: "Save")
                if status["status"] as! Bool == false{
                    saveInfantInfo.updateValue("N" as AnyObject, forKey: "friend_and_family")
                }else{
                    saveInfantInfo.updateValue("Y" as AnyObject, forKey: "friend_and_family")
                    saveInfantInfo.updateValue("Infant" as AnyObject, forKey: "passenger_type")
                    let passengerId = infantInfo["\(count)"] as! NSDictionary
                    
                    if (passengerId["id"] != nil && (passengerId["id"] as AnyObject).classForCoder != NSString.classForCoder()){
                        saveInfantInfo.updateValue(passengerId["id"] as! Int as AnyObject, forKey: "friend_and_family_id")
                    }

                }
            }
            
            let expiredDate = nilIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationExpiredDate, count)] as AnyObject)
            var arrangeExpDate = [String]()
            var newExpDate = String()
            
            if expiredDate != ""{
                arrangeExpDate = expiredDate.components(separatedBy: "-")
                newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
            }
            
            saveInfantInfo.updateValue(newExpDate as AnyObject, forKey: "expiration_date")
            
            infant.updateValue(saveInfantInfo as AnyObject, forKey: "\(j)")
            infantInfo.updateValue(saveInfantInfo as AnyObject, forKey: "\(j)")
            tempInfant.append(saveInfantInfo as AnyObject)
        }
        
        let bookId = String(format: "%i", (defaults.object(forKey: "booking_id")! as AnyObject).integerValue)
        let signature = defaults.object(forKey: "signature") as! String
        defaults.set(infant, forKey: "infant")
        defaults.set(passenger, forKey: "passengerData")
        defaults.synchronize()
        
        let firstPassenger = passengerName[0]
        var nameDuplicate = Bool()
        
        for i in 1..<passengerName.count{
            if passengerName[i] == firstPassenger{
                nameDuplicate = true
            }
        }
        
        var checkTravelWith = Bool()
        if travelWith.count != 0{
            
            let a = Array(Set(travelWith))
            
            if a.count == travelWith.count{
                checkTravelWith = true
            }
            
        }
        return (tempPassenger, tempInfant, bookId, signature, nameDuplicate, checkTravelWith)
    }
    
    func addExpiredDate(_ sender:NSNotification){
        let newTag = (sender.userInfo!["tag"]! as AnyObject).components(separatedBy: "(")
        
        addExpiredDateRow(newTag[1], date: "")
        
    }
    
    func addExpiredDateRow(_ tag : String, date: String){
        
        var row : XLFormRowDescriptor
        
        // Date
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,tag), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Expiration Date:*")
        row.isRequired = true
        
        if date != ""{
            row.value = formatDate(stringToDate(date))
        }
        //
        self.form.addFormRow(row, afterRowTag: String(format: "%@(%@",Tags.ValidationDocumentNo, tag))
    }
    
    func removeExpiredDate(_ sender:NSNotification){
        
        let newTag = (sender.userInfo!["tag"]! as AnyObject).components(separatedBy: "(")
        self.form.removeFormRow(withTag: String(format: "%@(%@",Tags.ValidationExpiredDate, newTag[1]))
        
    }
    
    func manageButtonClicked(){
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewController(withIdentifier: "FamilyListVC") as! FamilyListViewController
        manageFamilyVC.familyAndFriendList = familyAndFriendList
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    var infantSelect = [String : AnyObject]()
    var adultSelect = [String : AnyObject]()
    func selectButtonClicked(_ sender : UIButton){
        
        //print(sender.accessibilityHint)
        for i in 0..<adultCount{
            var count = i
            count += 1
            var saveAdultInfo = [String:AnyObject]()
            saveAdultInfo.updateValue(getTitleCode(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as AnyObject), titleArr: titleArray) as AnyObject, forKey: "title")
            saveAdultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]! as AnyObject, forKey: "first_name")
            saveAdultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]! as AnyObject, forKey: "last_name")
            
            saveAdultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as AnyObject?) as AnyObject , forKey: "dob2")
            saveAdultInfo.updateValue(getCountryCode(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationCountry, count)] as AnyObject), countryArr: countryArray) as AnyObject, forKey: "issuing_country")
            saveAdultInfo.updateValue("" as AnyObject, forKey: "gender")
            if flightType == "FY"{
                saveAdultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)] as AnyObject) as AnyObject, forKey: "bonuslink")
            }
            saveAdultInfo.updateValue("Adult" as AnyObject, forKey: "type")
            if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                saveAdultInfo.updateValue((formValues()[String(format: "%@(adult%i)", Tags.SaveFamilyAndFriend, count)] as AnyObject)["status"] as! Bool as AnyObject, forKey: "Save")
            }
            adultInfo.updateValue(saveAdultInfo as AnyObject, forKey: "\(i)")
        }
        
        for j in 0..<infantCount{
            var count = j
            count = count + 1
            var saveInfantInfo = [String:AnyObject]()
            
            saveInfantInfo.updateValue(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray) as AnyObject, forKey: "traveling_with")
            saveInfantInfo.updateValue(getGenderCode(nullIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationGender, count)] as AnyObject), genderArr: genderArray as [Dictionary<String, AnyObject>]) as AnyObject, forKey: "gender")
            saveInfantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationFirstName, count)]! as AnyObject, forKey: "first_name")
            saveInfantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationLastName, count)]! as AnyObject, forKey: "last_name")
            saveInfantInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as AnyObject?) as AnyObject , forKey: "dob2")
            saveInfantInfo.updateValue("NRIC" as AnyObject, forKey: "travel_document")
            saveInfantInfo.updateValue(getCountryCode(nullIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationCountry, count)] as AnyObject), countryArr: countryArray) as AnyObject, forKey: "issuing_country")
            saveInfantInfo.updateValue("" as AnyObject, forKey: "document_number")
            saveInfantInfo.updateValue((formValues()[String(format: "%@(infant%i)", Tags.SaveFamilyAndFriend, count)] as AnyObject)["status"] as! Bool as AnyObject, forKey: "Save")
            infantInfo.updateValue(saveInfantInfo as AnyObject, forKey: "\(count)")
            
        }
        
        let type = (sender.accessibilityHint)!.components(separatedBy: " ")
        
        if type[0] == "ADULT"{
            let picker = ActionSheetStringPicker(title: "", rows: adultName, initialSelection: adultSelect["\(sender.tag)"] as! Int, target: self, successAction: #selector(self.adultSelected(_:element:)), cancelAction: #selector(self.actionPickerCancelled(_:)), origin: sender)
            picker?.show()
        }else{
            let picker = ActionSheetStringPicker(title: "", rows: infantName, initialSelection: infantSelect["\(sender.tag)"] as! Int, target: self, successAction: #selector(self.infantSelected(_:element:)), cancelAction: #selector(self.actionPickerCancelled(_:)), origin: sender)
            picker?.show()

        }
        

    }
    
    func adultSelected(_ index :NSNumber, element:AnyObject){
       
    }
    
    func infantSelected(_ index :NSNumber, element:AnyObject){
        
    }
    
    func actionPickerCancelled(_ sender:AnyObject){
        //do nothing
    }
    
    func saveFamilyAndFriends(_ familyAndFriendInfo : [AnyObject]){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userList = Results<FamilyAndFriendList>!()
        let userList = realm.objects(FamilyAndFriendList.self)
        let mainUser = userList.filter("email == \(userInfo["username"] as! String)")
        
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
            data.gender = nullIfEmpty(list["gender"] as AnyObject)
            data.firstName = list["first_name"] as! String
            data.lastName = list["last_name"] as! String
            let dateArr = (list["dob"] as! String).components(separatedBy: "-")
            data.dob = "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            data.country = list["nationality"] as! String
            data.bonuslink = list["bonuslink_card"] as! String
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
     for list in saveFamilyAndFriend{
     
     let data = FamilyAndFriendData()
     data.id = list["id"] as! Int
     data.title = list["title"] as! String
     data.gender = nullIfEmpty(list["gender"]) as! String
     data.firstName = list["first_name"] as! String
     data.lastName = list["last_name"] as! String
     let dateArr = (list["dob"] as! String).components(separatedBy: "-")
     data.dob = "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
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
     
     */
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

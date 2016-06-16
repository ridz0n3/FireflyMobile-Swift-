//
//  FamilyListViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/6/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView
import SwiftyJSON

class FamilyListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var returnPassengerButton: UIButton!
    @IBOutlet weak var addAdultButton: UIButton!
    @IBOutlet weak var addInfantButton: UIButton!
    @IBOutlet weak var familyListTableView: UITableView!
    var familyAndFriendList : List<FamilyAndFriendData>! = nil
    var familyAndFriend = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        
        familyListTableView.estimatedRowHeight = 80
        familyListTableView.rowHeight = UITableViewAutomaticDimension
        
        addAdultButton.layer.cornerRadius = 10
        addInfantButton.layer.cornerRadius = 10
        returnPassengerButton.layer.cornerRadius = 10
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FamilyListViewController.reloadList(_:)), name: "reloadList", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadList(sender:NSNotification){
        
        let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
        var userList = Results<FamilyAndFriendList>!()
        userList = realm.objects(FamilyAndFriendList)
        let mainUser = userList.filter("email == %@",userInfo["username"] as! String)
        
        if mainUser.count != 0{
            if mainUser[0].familyList.count != 0{
                familyAndFriendList = mainUser[0].familyList
                familyListTableView.reloadData()
            }
        }else{
            familyAndFriendList = nil
            familyListTableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if familyAndFriendList != nil{
            if familyAndFriendList.count == 0{
                return 1
            }else{
                return familyAndFriendList.count
            }
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if familyAndFriendList != nil{
            if familyAndFriendList.count == 0{
                return 85
            }else{
                return UITableViewAutomaticDimension
            }
        }else{
            return 85
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if familyAndFriendList != nil{
            if familyAndFriendList.count == 0{
                let cell = self.familyListTableView.dequeueReusableCellWithIdentifier("NoData", forIndexPath: indexPath)
                return cell
            }else{
                
                let cell = self.familyListTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomFamilyListTableViewCell
                
                let familyInfo = familyAndFriendList[indexPath.row]
                
                cell.deleteButton.addTarget(self, action: #selector(FamilyListViewController.deleteBtnPressed(_:)), forControlEvents: .TouchUpInside)
                cell.deleteButton.tag = indexPath.row
                
                cell.editBtn.addTarget(self, action: #selector(FamilyListViewController.editBtnPressed(_:)), forControlEvents: .TouchUpInside)
                cell.editBtn.tag = indexPath.row
                
                if familyInfo.type == "Infant"{
                    cell.nameLbl.text = "\(familyInfo.firstName) \(familyInfo.lastName)".capitalizedString
                }else{
                    cell.nameLbl.text = "\(familyInfo.title) \(familyInfo.firstName) \(familyInfo.lastName)".capitalizedString
                }
                
                
                return cell
            }
        }else{
            let cell = self.familyListTableView.dequeueReusableCellWithIdentifier("NoData", forIndexPath: indexPath)
            return cell
        }
    }
    
    @IBAction func AddAdultBtnPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewControllerWithIdentifier("AddAdultVC") as! AddAdultViewController
        manageFamilyVC.action = "add"
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    @IBAction func AddInfantBtnPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewControllerWithIdentifier("AddInfantVC") as! AddInfantViewController
        manageFamilyVC.action = "add"
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    @IBAction func ReturnPassengerBtnPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPicker", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    var deleteTag = Int()
    func deleteBtnPressed(sender : AnyObject){
        let btn = sender as! UIButton
        
        deleteTag = btn.tag
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCircularIcon: true,
            kCircleIconHeight: 40
        )
        let alertViewIcon = UIImage(named: "alertIcon")
        
        let infoView = SCLAlertView(appearance:appearance)
        infoView.addButton("Confirm", target: self, selector: #selector(FamilyListViewController.deleteFamily))
        infoView.showInfo("Delete", subTitle: "Are you sure want to delete?", closeButtonTitle: "Cancel", colorStyle: 0xEC581A, circleIconImage: alertViewIcon)
    }
    
    func deleteFamily(){
        let userId = familyAndFriendList[deleteTag].id
        let info = defaults.objectForKey("userInfo") as! NSDictionary
        let email = info["username"] as! String
        
        showLoading()
        
        FireFlyProvider.request(.DeleteFamilyAndFriend(userId, email)) { (result) in
            
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        showToastMessage("User successfully deleted")
                        self.saveFamilyAndFriend(json["family_and_friend"].arrayObject!)
                        NSNotificationCenter.defaultCenter().postNotificationName("reloadList", object: nil)
                        
                        // self.navigationController?.popViewControllerAnimated(true)
                    }else if json["status"] == "error"{
                        showErrorMessage(json["message"].string!)
                    }else if json["status"].string == "401"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                        
                        for views in (self.navigationController?.viewControllers)!{
                            if views.classForCoder == HomeViewController.classForCoder(){
                                self.navigationController?.popToViewController(views, animated: true)
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                            }
                        }
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
    
    func editBtnPressed(sender : AnyObject){
        
        let btn = sender as! UIButton
        let familyInfo = familyAndFriendList[btn.tag]
        
        if familyInfo.type == "Infant"{
            
            let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
            let manageFamilyVC = storyboard.instantiateViewControllerWithIdentifier("AddInfantVC") as! AddInfantViewController
            manageFamilyVC.action = "edit"
            manageFamilyVC.familyAndFriendInfo = familyInfo
            self.navigationController?.pushViewController(manageFamilyVC, animated: true)
            
        }else{
            
            let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
            let manageFamilyVC = storyboard.instantiateViewControllerWithIdentifier("AddAdultVC") as! AddAdultViewController
            manageFamilyVC.action = "edit"
            manageFamilyVC.familyAndFriendInfo = familyInfo
            self.navigationController?.pushViewController(manageFamilyVC, animated: true)
            
        }
        
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
            
            for list in familyAndFriendInfo{
                
                let data = FamilyAndFriendData()
                data.id = list["id"] as! Int
                data.title = list["title"] as! String
                data.gender = nullIfEmpty(list["gender"]) as! String
                data.firstName = list["first_name"] as! String
                data.lastName = list["last_name"] as! String
                data.dob = list["dob"] as! String
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
            
            if familyAndFriendInfo.count == 0{
                realm.beginWrite()
                realm.delete(mainUser[0])
                try! realm.commitWrite()
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

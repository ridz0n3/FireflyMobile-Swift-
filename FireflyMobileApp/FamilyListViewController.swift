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
        addAdultButton.layer.borderWidth = 1
        addInfantButton.layer.borderWidth = 1
        addAdultButton.layer.borderColor = UIColor.orange.cgColor
        addInfantButton.layer.borderColor = UIColor.orange.cgColor
        returnPassengerButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(FamilyListViewController.reloadList(_:)), name: NSNotification.Name(rawValue: "reloadList"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadList(_ sender:NSNotification){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userList = Results<FamilyAndFriendList>!()
        let userList = realm.objects(FamilyAndFriendList.self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if familyAndFriendList != nil{
            if familyAndFriendList.count == 0{
                let cell = self.familyListTableView.dequeueReusableCell(withIdentifier: "NoData", for: indexPath)
                return cell
            }else{
                
                let cell = self.familyListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomFamilyListTableViewCell
                
                let familyInfo = familyAndFriendList[indexPath.row]
                
                cell.deleteButton.addTarget(self, action: #selector(FamilyListViewController.deleteBtnPressed(_:)), for: .touchUpInside)
                cell.deleteButton.tag = indexPath.row
                
                cell.editBtn.addTarget(self, action: #selector(FamilyListViewController.editBtnPressed(_:)), for: .touchUpInside)
                cell.editBtn.tag = indexPath.row
                
                if familyInfo.type == "Infant"{
                    cell.nameLbl.text = "\(familyInfo.firstName) \(familyInfo.lastName)".capitalized
                }else{
                    cell.nameLbl.text = "\(familyInfo.title) \(familyInfo.firstName) \(familyInfo.lastName)".capitalized
                }
                
                
                return cell
            }
        }else{
            let cell = self.familyListTableView.dequeueReusableCell(withIdentifier: "NoData", for: indexPath)
            return cell
        }
    }
    
    @IBAction func AddAdultBtnPressed(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewController(withIdentifier: "AddAdultVC") as! AddAdultViewController
        manageFamilyVC.action = "add"
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    @IBAction func AddInfantBtnPressed(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewController(withIdentifier: "AddInfantVC") as! AddInfantViewController
        manageFamilyVC.action = "add"
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    @IBAction func ReturnPassengerBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPicker"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    var deleteTag = Int()
    func deleteBtnPressed(_ sender : AnyObject){
        let btn = sender as! UIButton
        
        deleteTag = btn.tag
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            //kCircleHeight: 40,
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCircularIcon: false
        )
        
        let alertViewIcon = UIImage(named: "alertIcon")
        
        let infoView = SCLAlertView(appearance:appearance)
        infoView.addButton("Confirm", target: self, selector: #selector(FamilyListViewController.deleteFamily))
        infoView.showInfo("Delete", subTitle: "Are you sure want to delete?", closeButtonTitle: "Cancel", colorStyle: 0xEC581A, circleIconImage: alertViewIcon)
    }
    
    func deleteFamily(){
        let userId = familyAndFriendList[deleteTag].id
        let info = defaults.object(forKey: "userInfo") as! NSDictionary
        let email = info["username"] as! String
        
        showLoading()
        
        FireFlyProvider.request(.DeleteFamilyAndFriend(userId, email)) { (result) in
            
            switch result {
            case .success(let successResult):
                do {
                    
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        showToastMessage("User successfully deleted")
                        self.saveFamilyAndFriend(json["family_and_friend"].arrayObject! as [AnyObject])
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadList"), object: nil)
                        
                        // self.navigationController?.popViewControllerAnimated(true)
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
    
    func editBtnPressed(_ sender : AnyObject){
        
        let btn = sender as! UIButton
        let familyInfo = familyAndFriendList[btn.tag]
        
        if familyInfo.type == "Infant"{
            
            let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
            let manageFamilyVC = storyboard.instantiateViewController(withIdentifier: "AddInfantVC") as! AddInfantViewController
            manageFamilyVC.action = "edit"
            manageFamilyVC.familyAndFriendInfo = familyInfo
            self.navigationController?.pushViewController(manageFamilyVC, animated: true)
            
        }else{
            
            let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
            let manageFamilyVC = storyboard.instantiateViewController(withIdentifier: "AddAdultVC") as! AddAdultViewController
            manageFamilyVC.action = "edit"
            manageFamilyVC.familyAndFriendInfo = familyInfo
            self.navigationController?.pushViewController(manageFamilyVC, animated: true)
            
        }
        
    }
    
    func saveFamilyAndFriend(_ familyAndFriendInfo : [AnyObject]){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userList = Results<FamilyAndFriendList>!()
        let userList = realm.objects(FamilyAndFriendList.self)
        let mainUser = userList.filter("email == %@",userInfo["username"] as! String)
        
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
                data.gender = nullIfEmpty(list["gender"] as AnyObject) 
                data.firstName = list["first_name"] as! String
                data.lastName = list["last_name"] as! String
                data.dob = list["dob"] as! String
                data.country = list["nationality"] as! String
                data.bonuslink = list["bonuslink_card"] as! String
                data.enrich = list["enrich"] as! String
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

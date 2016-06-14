//
//  FamilyListViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/6/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import RealmSwift

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
        
        if mainUser[0].familyList.count != 0{
            familyAndFriendList = mainUser[0].familyList
            familyListTableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if familyAndFriendList.count == 0{
            return 1
        }else{
            return familyAndFriendList.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if familyAndFriendList.count == 0{
            return 85
        }else{
            return UITableViewAutomaticDimension
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    
    func deleteBtnPressed(sender : AnyObject){
        let btn = sender as! UIButton
        print("delete \(btn.tag)")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  FamilyListViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/6/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class FamilyListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var returnPassengerButton: UIButton!
    @IBOutlet weak var addAdultButton: UIButton!
    @IBOutlet weak var addInfantButton: UIButton!
    @IBOutlet weak var familyListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        addAdultButton.layer.cornerRadius = 10
        addInfantButton.layer.cornerRadius = 10
        returnPassengerButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.familyListTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomFamilyListTableViewCell
        
        cell.nameLbl.text = "test"
        
        return cell
    }
    
    @IBAction func AddAdultBtnPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "FamilyAndFriend", bundle: nil)
        let manageFamilyVC = storyboard.instantiateViewControllerWithIdentifier("AddAdultVC") as! AddAdultViewController
        self.navigationController?.pushViewController(manageFamilyVC, animated: true)
        
    }
    
    @IBAction func AddInfantBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func ReturnPassengerBtnPressed(sender: AnyObject) {
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

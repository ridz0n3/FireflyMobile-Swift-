//
//  CustomFlightPickerViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 5/23/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class CustomFlightPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var destinationType = String()
    var picker = [String]()
    var selectPicker = Int()
    @IBOutlet weak var pickerTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pickerTableView.layer.cornerRadius = 10
        pickerTableView.layer.borderColor = UIColor.orange.cgColor
        pickerTableView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: selectPicker, section: 0)
        pickerTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picker.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pickerTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = bgColorView
        
        cell.textLabel?.text = picker[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        if destinationType == "departure"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "departureSelected"), object: nil, userInfo: ["index" : indexPath.row])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "arrivalSelected"), object: nil, userInfo: ["index" : indexPath.row])
        }
        
    }
    
    @IBAction func closedButtonPressed(_ sender: AnyObject) {
        
         self.dismiss(animated: true, completion: nil)
        
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

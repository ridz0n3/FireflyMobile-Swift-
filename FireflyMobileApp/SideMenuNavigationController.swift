//
//  SideMenuNavigationController.swift
//  FireflyMobileApp
//
//  Created by Me-Tech on 12/15/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class SideMenuNavigationController: ENSideMenuNavigationController {
    
    override func viewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menu = storyboard.instantiateViewControllerWithIdentifier("sideMenuVC") as! SideMenuTableViewController
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menu, menuPosition: ENSideMenuPosition.Left)
        sideMenu?.menuWidth = 180
        view.bringSubviewToFront(navigationBar)
        
    }
    
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
}

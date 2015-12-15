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
        
        let menu = storyboard.instantiateViewControllerWithIdentifier("SideMenuTableViewController") as! SideMenuTableViewController
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menu, menuPosition: ENSideMenuPosition.Left)
        sideMenu?.menuWidth = 180
        view.bringSubviewToFront(navigationBar)
    }

}

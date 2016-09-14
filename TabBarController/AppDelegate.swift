//
//  AppDelegate.swift
//  TabBarController
//
//  Created by Aaron on 16/8/19.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ZZTabBarControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var viewControllers: [UIViewController] = []
        
        // MARK: - Home
        let homeViewController: HomeViewController = HomeViewController()
//        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: - Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: - Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        planViewController.zz_tabBarItem.badgeValue = "10"
        viewControllers.append(planViewController)
        
        // MARK: - Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: - Custom Item
        let customItem: ZZTabBarItem = ZZTabBarItem()
        customItem.itemType = .Action
        customItem.image = UIImage(named: "home_circle")
        
        // MARK: - TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        tabBarViewController.delegate = self
        
//        tabBarViewController.viewControllers = viewControllers
        
        tabBarViewController.setupViewControllers(viewControllers, customItem: (customItem, 2))
        
//        let bgView = UIView()
//        bgView.backgroundColor = UIColor.lightGrayColor()
//        tabBarViewController.tabBar.backgroundView = bgView
        // MARK: - Window
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: - ZZTabBarControllerDelegate
    func tabBarController(tabBarController: ZZTabBarController, didSelectCustomItemIndex index: Int) -> Void {
        print("Custom Item At Index \(index) Click")
    }
    
    func tabBarController(tabBarController: ZZTabBarController, badgeClearAtIndex index: Int) {
        print("清空badge : \(index)")
    }
}


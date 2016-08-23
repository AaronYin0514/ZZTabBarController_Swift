//
//  AppDelegate.swift
//  TabBarController
//
//  Created by Aaron on 16/8/19.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var viewControllers: [UIViewController] = []
        
        // MARK: - TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        
        // MARK: - Home
        let homeViewController: HomeViewController = HomeViewController()
        viewControllers.append(homeViewController)
        // MARK: - Map
        let mapViewController: MapViewController = MapViewController()
        viewControllers.append(mapViewController)
        // MARK: - Plan
        let planViewController: PlanViewController = PlanViewController()
        viewControllers.append(planViewController)
        // MARK: - Setting
        let settingViewController: SettingViewController = SettingViewController()
        viewControllers.append(settingViewController)
        
        tabBarViewController.setupViewControllers(viewControllers)
        
        
        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.unselectedImage = UIImage(named: "home")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "home_selected");
        
        
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.unselectedImage = UIImage(named: "maps")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "maps_selected")
        
        
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.unselectedImage = UIImage(named: "myplan")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "myplan_selected")
        planViewController.zz_tabBarItem.badgeValue = "10"
        
        
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.unselectedImage = UIImage(named: "settings")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "settings_selected")
        
        // MARK: - Window
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}


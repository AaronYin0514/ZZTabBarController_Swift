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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /**
         案例一
         高仿系统UITabBarController
         使用方法与UITabBarController完全相同
         扩展了Badge功能，设置Badge值动画
         仿QQ Badge效果，可拖动消除
         */
//        let tabBarViewController: ZZTabBarController = self.case1()
        /**
         案例二
         设置自定义按钮，代理中实现点击方法
         这样的例子很多，比如微博中间的发微博按钮，微拍拍视频的按钮等等
         */
        let tabBarViewController: ZZTabBarController = self.case2()
        /**
         案例三
         黑色风格，设置TabBarItem选中和正常背景
         */
//        let tabBarViewController: ZZTabBarController = self.case3()
        /**
         案例四
         分割线
         */
//        let tabBarViewController: ZZTabBarController = self.case4()
        /**
         案例五
         自定义分割线图片
         */
//        let tabBarViewController: ZZTabBarController = self.case5()
        
        // MARK: - Window
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - 案例
    func case1() -> ZZTabBarController {
        var viewControllers: [UIViewController] = []
        // MARK: Home
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        planViewController.zz_tabBarItem.badgeValue = "10"
        viewControllers.append(planViewController)
        
        // MARK: Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        tabBarViewController.badgeAnimation = true
        tabBarViewController.viewControllers = viewControllers
        
        return tabBarViewController
    }
    
    func case2() -> ZZTabBarController {
        var viewControllers: [UIViewController] = []
        // MARK: Home
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.zz_tabBarItem.title = "主页"
        homeViewController.zz_tabBarItem.image = UIImage(named: "nav_home_normal")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "nav_home_pressed")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 43.0 / 255.0, green: 176.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "列表"
        mapViewController.zz_tabBarItem.image = UIImage(named: "nav_list_normal")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "nav_list_pressed")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 43.0 / 255.0, green: 176.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "关注"
        planViewController.zz_tabBarItem.image = UIImage(named: "nav_star_normal")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "nav_star_pressed")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 43.0 / 255.0, green: 176.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)]
        viewControllers.append(planViewController)
        
        // MARK: Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "账户"
        settingViewController.zz_tabBarItem.image = UIImage(named: "nav_person_normal")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "nav_person_pressed")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 43.0 / 255.0, green: 176.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: Custom Item
        let customItem: ZZTabBarItem = ZZTabBarItem()
        customItem.itemHeight = 59.0
        customItem.itemType = .action
        customItem.image = UIImage(named: "home_circle")
        
        // MARK: TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        tabBarViewController.delegate = self
        let bgView = UIImageView(image: UIImage(named: "bottom_pink"))
        tabBarViewController.tabBar.backgroundView = bgView
        tabBarViewController.setupViewControllers(viewControllers, customItem: (customItem, 2))
        
        return tabBarViewController
    }
    
    func case3() -> ZZTabBarController {
        var viewControllers: [UIViewController] = []
        // MARK: Home
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
        homeViewController.zz_tabBarItem.selectedBackgroundImage = UIImage(named: "tabbar_selected")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
        mapViewController.zz_tabBarItem.selectedBackgroundImage = UIImage(named: "tabbar_selected")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
        planViewController.zz_tabBarItem.selectedBackgroundImage = UIImage(named: "tabbar_selected")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        planViewController.zz_tabBarItem.badgeValue = "10"
        viewControllers.append(planViewController)
        
        // MARK: Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
        settingViewController.zz_tabBarItem.selectedBackgroundImage = UIImage(named: "tabbar_selected")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        let bgView = UIView()
        bgView.backgroundColor = UIColor.darkGray
        tabBarViewController.tabBar.backgroundView = bgView
        tabBarViewController.viewControllers = viewControllers
        
        return tabBarViewController
    }
    
    func case4() -> ZZTabBarController {
        var viewControllers: [UIViewController] = []
        // MARK: Home
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        planViewController.zz_tabBarItem.badgeValue = "10"
        viewControllers.append(planViewController)
        
        // MARK: Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        tabBarViewController.badgeAnimation = true
        tabBarViewController.showSeparationLine = true
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        tabBarViewController.tabBar.backgroundView = bgView
        tabBarViewController.viewControllers = viewControllers
        
        return tabBarViewController
    }
    
    func case5() -> ZZTabBarController {
        var viewControllers: [UIViewController] = []
        // MARK: Home
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.zz_tabBarItem.title = "Home"
        homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
        homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
        homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(homeViewController)
        
        // MARK: Map
        let mapViewController: MapViewController = MapViewController()
        mapViewController.zz_tabBarItem.title = "Map"
        mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
        mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
        mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        viewControllers.append(mapViewController)
        
        // MARK: Plan
        let planViewController: PlanViewController = PlanViewController()
        planViewController.zz_tabBarItem.title = "Plan"
        planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
        planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
        planViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        planViewController.zz_tabBarItem.badgeValue = "10"
        viewControllers.append(planViewController)
        
        // MARK: Setting
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.zz_tabBarItem.title = "Setting"
        settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
        settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
        settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
        let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
        viewControllers.append(settingNavigation)
        
        // MARK: TabBarController
        let tabBarViewController: ZZTabBarController = ZZTabBarController()
        tabBarViewController.badgeAnimation = true
        tabBarViewController.showSeparationLine = true
        tabBarViewController.tabBar.separationLineImage = UIImage(named: "unipay_bgarrow")
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        tabBarViewController.tabBar.backgroundView = bgView
        tabBarViewController.viewControllers = viewControllers
        
        return tabBarViewController
    }

    // MARK: - ZZTabBarControllerDelegate
    func tabBarController(_ tabBarController: ZZTabBarController, didSelectCustomItemIndex index: Int) -> Void {
        let alertController = UIAlertController(title: "ZZTabBarController", message: "自定义按钮", preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertBtn)
        (window!.rootViewController as! ZZTabBarController).selectedViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: ZZTabBarController, badgeClearAtIndex index: Int) {
        print("清空badge : \(index)")
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

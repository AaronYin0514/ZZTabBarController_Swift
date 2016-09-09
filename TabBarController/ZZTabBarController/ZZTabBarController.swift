//
//  ZZTabBarController.swift
//  TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZTabBarController: UIViewController, ZZTabBarDelegate {
    /**
     * The tab bar controller’s delegate object.
     */
    weak var delegate:ZZTabBarControllerDelegate?
    /**
     * An array of the root view controllers displayed by the tab bar interface.
     */
    private var private_viewControllers: [UIViewController]?
    var viewControllers:[UIViewController]? {
        get {
            return private_viewControllers
        }
        set(newValue) {
            if private_viewControllers != nil && private_viewControllers?.count > 0 {
                for viewController in private_viewControllers! {
                    viewController.willMoveToParentViewController(nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParentViewController()
                }
            }
            if newValue?.count > 0 {
                private_viewControllers = newValue
                var tempTabBarItems:[ZZTabBarItem] = []
                for viewController in private_viewControllers! {
                    viewController.zz_private_tabBarController = self
                    tempTabBarItems.append(viewController.zz_tabBarItem)
                }
                tabBar.items = tempTabBarItems
                selectedIndex = 0
            }
        }
    }
    /**
     * The tab bar view associated with this controller. (read-only)
     */
    private var privateTabBar :ZZTabBar = ZZTabBar()
    var tabBar:ZZTabBar {
        get {
            return privateTabBar
        }
    }
    /**
     * The view controller associated with the currently selected tab item.
     */
    weak var selectedViewController:UIViewController?
    /**
     * The index of the view controller associated with the currently selected tab item.
     */
    var selectedIndex: Int {
        set (index) {
            if index > viewControllers?.count || index < 0 {
                return
            }
            if selectedViewController != nil {
                selectedViewController?.willMoveToParentViewController(nil)
                selectedViewController?.view.removeFromSuperview()
                selectedViewController?.removeFromParentViewController()
            }
            tabBar.selectedItem = tabBar.items![index]
            
            let viewController = viewControllers![index]
            self.addChildViewController(viewController)
            viewController.view.frame = self.view.frame
            self.view.insertSubview(viewController.view, atIndex: 0)
            viewController.didMoveToParentViewController(self)
            
            selectedViewController = viewController
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
        get {
            return viewControllers!.indexOf(selectedViewController!)!
        }
    }
    /**
     * A Boolean value that determines whether the tab bar is hidden.
     */
    var tabBarHidden: Bool = false
    /**
     * Changes the visibility of the tab bar.
     */
    func setTabBarHidden(hidden: Bool, animated: Bool) -> Void {
        tabBarHidden = hidden
        weak var weakSelf : ZZTabBarController? = self
        
        let block: () -> Void = {
            let viewSize: CGSize = weakSelf!.view.bounds.size
            var tabBarStartingY: CGFloat = viewSize.height
            var contentViewHeight: CGFloat = viewSize.height
            var tabBarHeight: CGFloat = CGRectGetHeight(weakSelf!.tabBar.frame)
            
            if tabBarHeight <= 0.0 {
                tabBarHeight = 49.0
            }
            
            if weakSelf!.tabBarHidden == false {
                tabBarStartingY = viewSize.height - tabBarHeight
                if weakSelf!.tabBar.translucent == false {
                    
                    var temp = weakSelf!.tabBar.minimumContentHeight()
                    
                    if temp <= 0.0 {
                        temp = tabBarHeight
                    }
                    
                    contentViewHeight = contentViewHeight - temp
                }
            }
            
            weakSelf!.tabBar.frame = CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)
        }
        
        let completion = { (completion: Bool) -> Void in
            if weakSelf!.tabBarHidden == true {
                weakSelf!.tabBar.hidden = true
            }
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: block, completion: completion)
        } else {
            block()
            completion(true)
        }
    }
    
    private func setupTabBar() {
        tabBar.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        tabBar.delegate = self
    }
    
    // MARK: - Life Cercle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.view.addSubview(tabBar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setTabBarHidden(tabBarHidden, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setTabBarHidden(tabBarHidden, animated: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return selectedViewController!.preferredStatusBarStyle()
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return selectedViewController!.preferredStatusBarUpdateAnimation()
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        var orientationMask:UIInterfaceOrientationMask = .All
//        for viewController in viewControllers! {
//            if viewController.respondsToSelector(#selector(UIViewController.supportedInterfaceOrientations)) == false {
//                return .Portrait
//            }
//            let supportedOrientations:UIInterfaceOrientationMask = viewController.supportedInterfaceOrientations()
//            if orientationMask.rawValue > supportedOrientations.rawValue {
//                orientationMask = supportedOrientations
//            }
//        }
//        return orientationMask
//    }
    
//    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        for viewController in viewControllers! {
//            if viewController.respondsToSelector(Selector("shouldAutorotateToInterfaceOrientation:") {
//            
//            }
//        }
//    }
    
    // MARK: - Methods
    func setupViewControllers(controllers: [UIViewController]) -> Void {
        if viewControllers != nil && viewControllers?.count > 0 {
            for viewController in viewControllers! {
                viewController.willMoveToParentViewController(nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }
        if controllers.count > 0 {
            viewControllers = controllers
            
            var tempTabBarItems:[ZZTabBarItem] = []
            
            for viewController in controllers {
                let tabBarItem: ZZTabBarItem = ZZTabBarItem()
                tabBarItem.title = viewController.title
                tempTabBarItems.append(tabBarItem)
                viewController.zz_private_tabBarController = self
            }
            tabBar.items = tempTabBarItems
            selectedIndex = 0
        }
    }
    
    func indexForViewController(viewController : UIViewController) -> Int {
        var searchViewController = viewController
        if viewController.navigationController != nil {
            searchViewController = viewController.navigationController!
        }
        return viewControllers!.indexOf(searchViewController)!
    }
    
    // MARK: - ZZTabBarDelegate
    func tabBar(tabBar: ZZTabBar, shouldSelectItemAtIndex index: Int) -> Bool {
        if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarControllerDelegate.tabBarController(_:shouldSelectViewController:))) {
            if delegate!.tabBarController!(self, shouldSelectViewController: viewControllers![index]) == false {
                return false
            }
            if selectedViewController == viewControllers![index] {
                return false
            }
        }
        return true
    }
    
    func tabBar(tabBar: ZZTabBar, didSelectItemAtIndex index: Int) {
        if index < 0 || index > viewControllers?.count {
            return;
        }
        selectedIndex = index
        if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarControllerDelegate.tabBarController(_:didSelectViewController:))) {
            delegate!.tabBarController!(self, didSelectViewController: viewControllers![index])
        }
    }
}

private var static_tabBarItem: ZZTabBarItem?
private var static_tabBarController: ZZTabBarController?

extension UIViewController {
    private var zz_private_tabBarItem: ZZTabBarItem? {
        get {
            return objc_getAssociatedObject(self, &static_tabBarItem) as? ZZTabBarItem
        }
        set(newValue) {
            objc_setAssociatedObject(self, &static_tabBarItem, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /**
     * The tab bar item that represents the view controller when added to a tab bar controller.
     */
    var zz_tabBarItem: ZZTabBarItem {
        get {
            if self.zz_private_tabBarItem == nil {
                self.zz_private_tabBarItem = ZZTabBarItem()
            }
            return self.zz_private_tabBarItem!
        }
    }
    
    var zz_private_tabBarController: ZZTabBarController? {
        get {
            var tabBarViewController = objc_getAssociatedObject(self, &static_tabBarController) as? ZZTabBarController
            if tabBarViewController == nil && self.parentViewController != nil {
                tabBarViewController = self.parentViewController?.zz_tabBarController
            }
            return tabBarViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &static_tabBarController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    /**
     * The nearest ancestor in the view controller hierarchy that is a tab bar controller. (read-only)
     */
    var zz_tabBarController: ZZTabBarController? {
        get {
            return zz_private_tabBarController
        }
    }
}

@objc protocol ZZTabBarControllerDelegate: NSObjectProtocol {
    /**
     * Asks the delegate whether the specified view controller should be made active.
     */
    optional func tabBarController(tabBarController: ZZTabBarController, shouldSelectViewController viewController:UIViewController) -> Bool
    /**
     * Tells the delegate that the user selected an item in the tab bar.
     */
    optional func tabBarController(tabBarController: ZZTabBarController, didSelectViewController viewController:UIViewController) -> Void
}

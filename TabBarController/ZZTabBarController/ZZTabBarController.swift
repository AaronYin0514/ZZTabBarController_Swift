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
    
    var badgeAnimation: Bool = false {
        didSet {
            if tabBar.normalItems != nil {
                for item in tabBar.normalItems! {
                    item.badgeLabel.animation = badgeAnimation
                }
            }
        }
    }
    
    var showSeparationLine: Bool = true {
        didSet {
            tabBar.showSeparationLine = showSeparationLine
        }
    }
    
    /**
     * An array of the root view controllers displayed by the tab bar interface.
     */
    fileprivate var private_viewControllers: [UIViewController]?
    var viewControllers:[UIViewController]? {
        get {
            return private_viewControllers
        }
        set(newValue) {
            if private_viewControllers != nil && private_viewControllers!.count > 0 {
                for viewController in private_viewControllers! {
                    viewController.willMove(toParentViewController: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParentViewController()
                }
            }
            if newValue != nil && newValue!.count > 0 {
                private_viewControllers = newValue
                var tempTabBarItems:[ZZTabBarItem] = []
                for (idx, viewController) in private_viewControllers!.enumerated() {
                    viewController.zz_private_tabBarController = self
                    var tabBarItem: ZZTabBarItem? = nil
                    if viewController.isKind(of: UINavigationController.self) {
                        tabBarItem = (viewController as! UINavigationController).viewControllers.first?.zz_tabBarItem
                    } else {
                        tabBarItem = viewController.zz_tabBarItem
                    }
                    if tabBarItem != nil {
                        tempTabBarItems.append(tabBarItem!)
                        tabBarItem?.index = idx
                    }
                }
                tabBar.normalItems = tempTabBarItems
                tabBar.items = tempTabBarItems
                selectedIndex = 0
            }
            badgeAnimation = badgeAnimation ? true : false
        }
    }
    
    func setupViewControllers(_ viewControllers: [UIViewController], customItem: (item: ZZTabBarItem, index: Int)) -> Void {
        var myCustomItem = customItem
        if myCustomItem.index < 0 {
            myCustomItem.index = 0
        }
        if myCustomItem.index > viewControllers.count {
            myCustomItem.index = viewControllers.count
        }
        if private_viewControllers != nil && private_viewControllers!.count > 0 {
            for viewController in private_viewControllers! {
                viewController.willMove(toParentViewController: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }
        if viewControllers.count > 0 {
            private_viewControllers = viewControllers
            var tempTabBarItems:[ZZTabBarItem] = []
            for (idx, viewController) in private_viewControllers!.enumerated() {
                viewController.zz_private_tabBarController = self
                var tabBarItem: ZZTabBarItem? = nil
                if viewController.isKind(of: UINavigationController.self) {
                    tabBarItem = (viewController as! UINavigationController).viewControllers.first?.zz_tabBarItem
                } else {
                    tabBarItem = viewController.zz_tabBarItem
                }
                if tabBarItem != nil {
                    tempTabBarItems.append(tabBarItem!)
                    tabBarItem?.index = idx
                }
            }
            tabBar.normalItems = tempTabBarItems
            tempTabBarItems.insert(myCustomItem.item, at: myCustomItem.index)
            tabBar.items = tempTabBarItems
            selectedIndex = 0
        }
        badgeAnimation = badgeAnimation ? true : false
    }
    
    /**
     * The tab bar view associated with this controller. (read-only)
     */
    fileprivate var privateTabBar :ZZTabBar = ZZTabBar()
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
            if viewControllers == nil {
                return
            }
            if index < 0 || index > viewControllers!.count {
                return
            }
            if selectedViewController != nil {
                selectedViewController?.willMove(toParentViewController: nil)
                selectedViewController?.view.removeFromSuperview()
                selectedViewController?.removeFromParentViewController()
            }
            tabBar.selectedItem = tabBar.normalItems![index]
            
            let viewController = viewControllers![index]
            self.addChildViewController(viewController)
            viewController.view.frame = self.view.frame
            self.view.insertSubview(viewController.view, at: 0)
            viewController.didMove(toParentViewController: self)
            
            selectedViewController = viewController
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
        get {
            return viewControllers!.index(of: selectedViewController!)!
        }
    }
    /**
     * A Boolean value that determines whether the tab bar is hidden.
     */
    var tabBarHidden: Bool = false
    /**
     * Changes the visibility of the tab bar.
     */
    func setTabBarHidden(_ hidden: Bool, animated: Bool) -> Void {
        tabBarHidden = hidden
        weak var weakSelf : ZZTabBarController? = self
        
        if hidden == false {
            weakSelf!.tabBar.isHidden = false
        }
        
        let block: () -> Void = {
            let viewSize: CGSize = weakSelf!.view.bounds.size
            var tabBarStartingY: CGFloat = viewSize.height
            var contentViewHeight: CGFloat = viewSize.height
            var tabBarHeight: CGFloat = weakSelf!.tabBar.frame.height
            
            if tabBarHeight <= 0.0 {
                tabBarHeight = 49.0
            }
            
            if weakSelf!.tabBarHidden == false {
                tabBarStartingY = viewSize.height - tabBarHeight
                var temp = weakSelf!.tabBar.minimumContentHeight()
                if temp <= 0.0 {
                    temp = tabBarHeight
                }
                contentViewHeight = contentViewHeight - temp
            }
            
            weakSelf!.tabBar.frame = CGRect(x: 0, y: tabBarStartingY, width: viewSize.width, height: tabBarHeight)
        }
        
        let completion = { (completion: Bool) -> Void in
            if hidden == true {
                weakSelf!.tabBar.isHidden = true
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: block, completion: completion)
        } else {
            block()
            completion(true)
        }
    }
    
    fileprivate func setupTabBar() {
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        tabBar.delegate = self
    }
    
    // MARK: - Life Cercle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.view.addSubview(tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNotification()
        self.setTabBarHidden(tabBarHidden, animated: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return selectedViewController!.preferredStatusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return selectedViewController!.preferredStatusBarUpdateAnimation
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotification()
    }
    
    // MARK: - Methods
    func setupViewControllers(_ controllers: [UIViewController]) -> Void {
        if viewControllers != nil && viewControllers!.count > 0 {
            for viewController in viewControllers! {
                viewController.willMove(toParentViewController: nil)
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
    
    func indexForViewController(_ viewController : UIViewController) -> Int {
        var searchViewController = viewController
        if viewController.navigationController != nil {
            searchViewController = viewController.navigationController!
        }
        return viewControllers!.index(of: searchViewController)!
    }
    
    // MARK: - Private Method
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ZZTabBarController.badgeClear(_:)), name: NSNotification.Name(rawValue: "com.zz.tabBarController.badgeClear"), object: nil)
    }
    
    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "com.zz.tabBarController.badgeClear"), object: nil)
    }
    
    func badgeClear(_ notification: Notification) {
        if delegate != nil && delegate!.responds(to: #selector(ZZTabBarControllerDelegate.tabBarController(_:badgeClearAtIndex:))) {
            let object = notification.object as! NSNumber
            delegate!.tabBarController!(self, badgeClearAtIndex: object.intValue)
        }
    }
    
    // MARK: - ZZTabBarDelegate
    func tabBar(_ tabBarItem: ZZTabBarItem, shouldSelectItemAtIndex index: Int) -> Bool {
        if delegate != nil && delegate!.responds(to: #selector(ZZTabBarControllerDelegate.tabBarController(_:shouldSelectViewController:))) {
            if delegate!.tabBarController!(self, shouldSelectViewController: viewControllers![index]) == false {
                return false
            }
            if selectedViewController == viewControllers![index] {
                return false
            }
        }
        return true
    }
    
    func tabBar(_ tabBarItem: ZZTabBarItem, didSelectItemAtIndex index: Int) {
        if viewControllers == nil {
            return
        }
        if index < 0 || index > viewControllers!.count {
            return;
        }
        selectedIndex = index
        if delegate != nil && delegate!.responds(to: #selector(ZZTabBarControllerDelegate.tabBarController(_:didSelectViewController:))) {
            delegate!.tabBarController!(self, didSelectViewController: viewControllers![index])
        }
    }
    
    func tabBar(_ tabBarItem: ZZTabBarItem, didSelectCustomItemAtIndex index: Int) -> Void {
        if delegate != nil && delegate!.responds(to: #selector(ZZTabBarControllerDelegate.tabBarController(_:didSelectCustomItemIndex:))) {
            delegate!.tabBarController!(self, didSelectCustomItemIndex: index)
        }
    }
}

private var static_tabBarItem: ZZTabBarItem?
private var static_tabBarController: ZZTabBarController?

extension UIViewController {
    fileprivate var zz_private_tabBarItem: ZZTabBarItem? {
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
            if tabBarViewController == nil && self.parent != nil {
                tabBarViewController = self.parent?.zz_tabBarController
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
    @objc optional func tabBarController(_ tabBarController: ZZTabBarController, shouldSelectViewController viewController:UIViewController) -> Bool
    /**
     * Tells the delegate that the user selected an item in the tab bar.
     */
    @objc optional func tabBarController(_ tabBarController: ZZTabBarController, didSelectViewController viewController:UIViewController)
    
    @objc optional func tabBarController(_ tabBarController: ZZTabBarController, didSelectCustomItemIndex index: Int)
    
    @objc optional func tabBarController(_ tabBarController: ZZTabBarController, badgeClearAtIndex index: Int)
}

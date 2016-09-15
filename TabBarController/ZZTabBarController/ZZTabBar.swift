//
//  ZZTabBar.swift
//  TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

let separationLineColor: UIColor = UIColor.lightGrayColor()

class ZZTabBar: UIView {
    
    var showSeparationLine: Bool = true {
        didSet {
            separationLine.hidden = showSeparationLine
        }
    }
    
    /**
     * The tab bar’s delegate object.
     */
    weak var delegate: ZZTabBarDelegate?
    /**
     * The items displayed on the tab bar.
     */
    var items:[ZZTabBarItem]? {
        willSet {
            if items != nil && items?.count > 0 {
                for item in items! {
                    item.removeFromSuperview()
                }
                items?.removeAll()
            }
        }
        didSet {
            for item in items! {
                item.translatesAutoresizingMaskIntoConstraints = false
                item.addTarget(self, action: #selector(ZZTabBar.tabBarItemWasSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(item)
            }
            self.setupLayoutItem()
        }
    }
    var normalItems: [ZZTabBarItem]?
    
    private var p_separationLine: UIView = UIView()
    var separationLine: UIView {
        get {
            return p_separationLine
        }
    }
    
    private func setupLayoutItem() {
        for constraint in self.constraints {
            if constraint.firstItem.isKindOfClass(ZZTabBarItem) {
                self.removeConstraint(constraint)
            }
        }
        for (idx, item) in (items!).enumerate() {
            let topConstraint = NSLayoutConstraint(item: item, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: self.contentEdgeInsets.top);
            self.addConstraint(topConstraint)
            
            let bottomConstraint = NSLayoutConstraint(item: item, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -self.contentEdgeInsets.bottom);
            self.addConstraint(bottomConstraint)
            
            var lastItem: ZZTabBarItem? = nil;
            
            if idx == 0 {
                let leftConstraint = NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: self.contentEdgeInsets.left);
                self.addConstraint(leftConstraint)
            } else {
                lastItem = items![idx - 1]
                let leadingConstraint = NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: lastItem, attribute: .Trailing, multiplier: 1.0, constant: self.contentEdgeInsets.left + self.contentEdgeInsets.right);
                self.addConstraint(leadingConstraint)
                
                if idx == items!.count - 1 {
                    let rightConstraint = NSLayoutConstraint(item: item, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -self.contentEdgeInsets.right);
                    self.addConstraint(rightConstraint)
                }
                
                let widthConstraint = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: lastItem, attribute: .Width, multiplier: 1.0, constant: 0.0);
                self.addConstraint(widthConstraint)
            }
        }
        self.setNeedsLayout()
    }
    /**
     * The currently selected item on the tab bar.
     */
    weak var selectedItem: ZZTabBarItem? {
        willSet (newValue) {
            selectedItem?.selected = false
        }
        didSet {
            selectedItem?.selected = true
        }
    }
    /**
     * backgroundView stays behind tabBar's items. If you want to add additional views,
     * add them as subviews of backgroundView.
     */
    private var p_backgroundView: UIView?
    var backgroundView: UIView {
        set(value) {
            p_backgroundView!.removeFromSuperview()
            p_backgroundView = nil
            p_backgroundView = value
            self.insertSubview(p_backgroundView!, atIndex: 0)
            self.setNeedsDisplay()
        }
        get {
            if p_backgroundView == nil {
                switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
                    case .OrderedSame, .OrderedDescending:
                        //"iOS >= 8.0"
                        p_backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
                    case .OrderedAscending:
                        //"iOS < 8.0"
                        p_backgroundView = UIView()
                        p_backgroundView!.backgroundColor = UIColor.whiteColor()
                }
            }
            return p_backgroundView!
        }
    }
    /*
     * contentEdgeInsets can be used to center the items in the middle of the tabBar.
     */
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            if UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, UIEdgeInsetsZero) == false {
                self.setupLayoutItem()
            }
        }
    }
    /**
     * Sets the height of tab bar.
     */
    func setHeight(height: CGFloat) -> Void {
        if height <= 0.0 {
            return
        }
        frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), height)
    }
    /**
     * Returns the minimum height of tab bar's items.
     */
    func minimumContentHeight() -> CGFloat {
        var minimumTabBarContentHeight = CGRectGetHeight(frame)
        for item: ZZTabBarItem in items! {
            let itemHeight = item.itemHeight
            if itemHeight > 0.0 && itemHeight < minimumTabBarContentHeight {
                minimumTabBarContentHeight = itemHeight
            }
        }
        return minimumTabBarContentHeight
    }
    /*
     * Enable or disable tabBar translucency. Default is fase.
     */
    var translucent: Bool = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() -> Void {
        self.addSubview(backgroundView)
        separationLine.backgroundColor = separationLineColor
        separationLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separationLine)
        self.setupSeparationLine()
        separationLine.hidden = showSeparationLine
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameSize = self.frame.size
        let minimumContentHeight = self.minimumContentHeight()
        backgroundView.frame = CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)
        self.bringSubviewToFront(separationLine)
    }
    
    private func setupSeparationLine() {
        let separationLineLeadingConstraint = NSLayoutConstraint(item: separationLine, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineLeadingConstraint)
        
        let separationLineTrailingConstraint = NSLayoutConstraint(item: separationLine, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineTrailingConstraint)
        
        let separationLineTopConstraint = NSLayoutConstraint(item: separationLine, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineTopConstraint)
        
        let separationLineHeightConstraint = NSLayoutConstraint(item: separationLine, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1.0)
        separationLine.addConstraint(separationLineHeightConstraint)
        
//        self.setNeedsDisplay()
    }
    
    // MARK: - Configuration
    private var itemWidth:CGFloat = 0.0
    
    //MARK: - Item selection
    func tabBarItemWasSelected(sender : ZZTabBarItem) -> Void {
        if sender.itemType == .Normal {
            if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarDelegate.tabBar(_:shouldSelectItemAtIndex:))) {
                let idx: Int = normalItems!.indexOf(sender)!
                if delegate!.tabBar!(sender, shouldSelectItemAtIndex: idx) == false {
                    return
                }
            }
            if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarDelegate.tabBar(_:didSelectItemAtIndex:))) {
                let idx: Int = normalItems!.indexOf(sender)!
                delegate!.tabBar!(sender, didSelectItemAtIndex: idx)
            }
        } else {
            if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarDelegate.tabBar(_:didSelectCustomItemAtIndex:))) {
                let idx: Int = items!.indexOf(sender)!
                delegate!.tabBar!(sender, didSelectCustomItemAtIndex: idx)
            }
        }
    }
}

@objc protocol ZZTabBarDelegate: NSObjectProtocol {
    /**
     * Asks the delegate if the specified tab bar item should be selected.
     */
    optional func tabBar(tabBarItem: ZZTabBarItem, shouldSelectItemAtIndex index:Int) -> Bool
    /**
     * Tells the delegate that the specified tab bar item is now selected.
     */
    optional func tabBar(tabBarItem: ZZTabBarItem, didSelectItemAtIndex index:Int) -> Void
    
    optional func tabBar(tabBarItem: ZZTabBarItem, didSelectCustomItemAtIndex index: Int) -> Void
}


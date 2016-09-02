//
//  ZZTabBar.swift
//  TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZTabBar: UIView {
    /**
     * The tab bar’s delegate object.
     */
    weak var delegate: ZZTabBarDelegate?
    /**
     * The items displayed on the tab bar.
     */
    var items:[ZZTabBarItem]? {
        didSet {
            for item in items! {
                item.removeFromSuperview()
            }
            for item in items! {
                item.addTarget(self, action: #selector(ZZTabBar.tabBarItemWasSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(item)
            }
        }
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
    private var backgroundView: UIView?
    /*
     * contentEdgeInsets can be used to center the items in the middle of the tabBar.
     */
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsetsZero
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
        self.commonInit()
    }
    
    func commonInit() -> Void {
        backgroundView = UIView()
        self.addSubview(backgroundView!)
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameSize = frame.size
        let minimumContentHeight = self.minimumContentHeight()
        
        backgroundView?.frame = CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)
        
        let width = ZZMathUtils.CGRoundf((frameSize.width - contentEdgeInsets.left -
            contentEdgeInsets.right) / CGFloat(items!.count))
        
        if width > 0 {
            itemWidth = width
        }
        
        for (idx, item) in (items!).enumerate() {
            var itemHeight = item.itemHeight
            if itemHeight <= 0.0 {
                itemHeight = frameSize.height
            }
            item.frame = CGRectMake(contentEdgeInsets.left + (CGFloat(idx) * self.itemWidth), ZZMathUtils.CGRoundf(frameSize.height - itemHeight) - contentEdgeInsets.top, itemWidth, itemHeight - contentEdgeInsets.bottom)
            item.setNeedsDisplay()
        }
    }
    
    // MARK: - Configuration
    private var itemWidth:CGFloat = 0.0
    
    
    //MARK: - Item selection
    func tabBarItemWasSelected(sender : ZZTabBarItem) -> Void {
        if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarDelegate.tabBar(_:shouldSelectItemAtIndex:))) {
            let idx: Int = items!.indexOf(sender)!
            if delegate!.tabBar!(self, shouldSelectItemAtIndex: idx) == false {
                return
            }
        }
        if delegate != nil && delegate!.respondsToSelector(#selector(ZZTabBarDelegate.tabBar(_:didSelectItemAtIndex:))) {
            let idx: Int = items!.indexOf(sender)!
            delegate!.tabBar!(self, didSelectItemAtIndex: idx)
        }
    }
}

@objc protocol ZZTabBarDelegate: NSObjectProtocol {
    /**
     * Asks the delegate if the specified tab bar item should be selected.
     */
    optional func tabBar(tabBar: ZZTabBar, shouldSelectItemAtIndex index:Int) -> Bool
    /**
     * Tells the delegate that the specified tab bar item is now selected.
     */
    optional func tabBar(tabBar: ZZTabBar, didSelectItemAtIndex index:Int) -> Void
}
//
//  ZZTabBar.swift
//  TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

let separationLineColor: UIColor = UIColor.lightGray

class ZZTabBar: UIView {
    
    var showSeparationLine: Bool = true {
        didSet {
            separationLine.isHidden = showSeparationLine
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
            if items != nil && items!.count > 0 {
                for item in items! {
                    item.removeFromSuperview()
                }
                items?.removeAll()
            }
        }
        didSet {
            for item in items! {
                item.translatesAutoresizingMaskIntoConstraints = false
                item.addTarget(self, action: #selector(ZZTabBar.tabBarItemWasSelected(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(item)
            }
            self.setupLayoutItem()
        }
    }
    var normalItems: [ZZTabBarItem]?
    
    fileprivate var p_separationLine: UIView = UIView()
    var separationLine: UIView {
        get {
            return p_separationLine
        }
    }
    
    fileprivate func setupLayoutItem() {
        for constraint in self.constraints {
            if constraint.firstItem.isKind(of: ZZTabBarItem.self) {
                self.removeConstraint(constraint)
            }
        }
        for (idx, item) in (items!).enumerated() {
            let bottomConstraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: self.contentEdgeInsets.bottom);
            self.addConstraint(bottomConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: item.itemHeight)
            item.addConstraint(heightConstraint)
            
            var lastItem: ZZTabBarItem? = nil;
            
            if idx == 0 {
                let leftConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: self.contentEdgeInsets.left);
                self.addConstraint(leftConstraint)
            } else {
                lastItem = items![idx - 1]
                let leadingConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: lastItem, attribute: .trailing, multiplier: 1.0, constant: self.contentEdgeInsets.left + self.contentEdgeInsets.right);
                self.addConstraint(leadingConstraint)
                
                if idx == items!.count - 1 {
                    let rightConstraint = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -self.contentEdgeInsets.right);
                    self.addConstraint(rightConstraint)
                }
                
                let widthConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: lastItem, attribute: .width, multiplier: 1.0, constant: 0.0);
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
            selectedItem?.isSelected = false
        }
        didSet {
            selectedItem?.isSelected = true
        }
    }
    /**
     * backgroundView stays behind tabBar's items. If you want to add additional views,
     * add them as subviews of backgroundView.
     */
    fileprivate var p_backgroundView: UIView?
    var backgroundView: UIView {
        set(value) {
            p_backgroundView!.removeFromSuperview()
            p_backgroundView = nil
            p_backgroundView = value
            self.insertSubview(p_backgroundView!, at: 0)
            self.layoutbackgroundView()
            self.setNeedsDisplay()
        }
        get {
            if p_backgroundView == nil {
                switch UIDevice.current.systemVersion.compare("8.0.0", options: NSString.CompareOptions.numeric) {
                    case .orderedSame, .orderedDescending:
                        //"iOS >= 8.0"
                        p_backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
                    case .orderedAscending:
                        //"iOS < 8.0"
                        p_backgroundView = UIView()
                        p_backgroundView!.backgroundColor = UIColor.white
                }
            }
            return p_backgroundView!
        }
    }
    
    fileprivate func layoutbackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        let backgroundViewTopConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewTopConstraint)
        
        let backgroundViewLeadingConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewLeadingConstraint)
        
        let backgroundViewTrailingConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewTrailingConstraint)
        
        let backgroundViewBottomConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewBottomConstraint)
    }
    
    /*
     * contentEdgeInsets can be used to center the items in the middle of the tabBar.
     */
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            if UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, UIEdgeInsets.zero) == false {
                self.setupLayoutItem()
            }
        }
    }
    /**
     * Returns the maxmum height of tab bar's items.
     */
    fileprivate var p_maxItemContentHeight: CGFloat = 0.0
    func maxItemContentHeight() -> CGFloat {
        if p_maxItemContentHeight > 0.0 {
            return p_maxItemContentHeight
        }
        var maxItemContentHeight = frame.height
        if items != nil {
            for item in items! {
                let itemHeight = item.itemHeight
                if itemHeight > maxItemContentHeight {
                    maxItemContentHeight = itemHeight
                }
            }
        }
        p_maxItemContentHeight = maxItemContentHeight
        return maxItemContentHeight
    }
    
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
        self.layoutbackgroundView()
        separationLine.backgroundColor = separationLineColor
        separationLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separationLine)
        self.setupSeparationLine()
        separationLine.isHidden = showSeparationLine
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubview(toFront: separationLine)
    }
    
    fileprivate func setupSeparationLine() {
        let separationLineLeadingConstraint = NSLayoutConstraint(item: separationLine, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineLeadingConstraint)
        
        let separationLineTrailingConstraint = NSLayoutConstraint(item: separationLine, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineTrailingConstraint)
        
        let separationLineTopConstraint = NSLayoutConstraint(item: separationLine, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineTopConstraint)
        
        let separationLineHeightConstraint = NSLayoutConstraint(item: separationLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
        separationLine.addConstraint(separationLineHeightConstraint)
    }
    
    // MARK: - Configuration
    fileprivate var itemWidth:CGFloat = 0.0
    
    //MARK: - Item selection
    func tabBarItemWasSelected(_ sender : ZZTabBarItem) -> Void {
        if sender.itemType == .normal {
            if delegate != nil && delegate!.responds(to: #selector(ZZTabBarDelegate.tabBar(_:shouldSelectItemAtIndex:))) {
                let idx: Int = normalItems!.index(of: sender)!
                if delegate!.tabBar!(sender, shouldSelectItemAtIndex: idx) == false {
                    return
                }
            }
            if delegate != nil && delegate!.responds(to: #selector(ZZTabBarDelegate.tabBar(_:didSelectItemAtIndex:))) {
                let idx: Int = normalItems!.index(of: sender)!
                delegate!.tabBar!(sender, didSelectItemAtIndex: idx)
            }
        } else {
            if delegate != nil && delegate!.responds(to: #selector(ZZTabBarDelegate.tabBar(_:didSelectCustomItemAtIndex:))) {
                let idx: Int = items!.index(of: sender)!
                delegate!.tabBar!(sender, didSelectCustomItemAtIndex: idx)
            }
        }
    }
}

@objc protocol ZZTabBarDelegate: NSObjectProtocol {
    /**
     * Asks the delegate if the specified tab bar item should be selected.
     */
    @objc optional func tabBar(_ tabBarItem: ZZTabBarItem, shouldSelectItemAtIndex index:Int) -> Bool
    /**
     * Tells the delegate that the specified tab bar item is now selected.
     */
    @objc optional func tabBar(_ tabBarItem: ZZTabBarItem, didSelectItemAtIndex index:Int) -> Void
    
    @objc optional func tabBar(_ tabBarItem: ZZTabBarItem, didSelectCustomItemAtIndex index: Int) -> Void
}


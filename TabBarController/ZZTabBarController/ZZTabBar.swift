//
//  ZZTabBar.swift
//  TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZTabBar: UIView {
    
    var showSeparationLine: Bool = false {
        didSet {
            separationLine.isHidden = !showSeparationLine
        }
    }
    
    /**
     * The tab bar’s delegate object.
     */
    weak var delegate: ZZTabBarDelegate?
    /**
     * The items displayed on the tab bar.
     */
    var items:[ZZTabBarItem] = [] {
        willSet {
            for item in items {
                item.removeFromSuperview()
            }
            items.removeAll()
        }
        didSet {
            for item in items {
                item.translatesAutoresizingMaskIntoConstraints = false
                item.addTarget(self, action: #selector(ZZTabBar.tabBarItemWasSelected(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(item)
            }
            self.setupLayoutItem()
        }
    }
    var normalItems: [ZZTabBarItem]?
    
    fileprivate var separationLine: UIImageView = UIImageView()
    var separationLineImage: UIImage? {
        didSet {
            if separationLineImage != nil {
                separationLine.image = separationLineImage
                if separationLineHeightConstraint != nil {
                    separationLineHeightConstraint!.constant = separationLineImage!.size.height
                    self.setNeedsDisplay()
                }
            } else {
                separationLine.image = nil
                if separationLineHeightConstraint != nil {
                    separationLineHeightConstraint!.constant = 1.0
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    var separationLineBackgroundColor: UIColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0) {
        didSet {
            separationLine.backgroundColor = separationLineBackgroundColor
        }
    }
    
    fileprivate func setupLayoutItem() {
        for constraint in self.constraints {
            if constraint.firstItem is ZZTabBarItem {
                self.removeConstraint(constraint)
            }
        }
        for (idx, item) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: self.contentEdgeInsets.top);
            self.addConstraint(topConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: item.itemHeight)
            item.addConstraint(heightConstraint)
            
            var lastItem: ZZTabBarItem? = nil;
            
            if idx == 0 {
                let leftConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: self.contentEdgeInsets.left);
                self.addConstraint(leftConstraint)
            } else {
                lastItem = items[idx - 1]
                let leadingConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: lastItem, attribute: .trailing, multiplier: 1.0, constant: self.contentEdgeInsets.left + self.contentEdgeInsets.right);
                self.addConstraint(leadingConstraint)
                
                if idx == items.count - 1 {
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
        let backgroundViewTopConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewTopConstraint)
        
        let backgroundViewLeadingConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewLeadingConstraint)
        
        let backgroundViewTrailingConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewTrailingConstraint)
        
        let backgroundViewBottomConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
        self.addConstraint(backgroundViewBottomConstraint)
    }
    
    /*
     * contentEdgeInsets can be used to center the items in the middle of the tabBar.
     */
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            if contentEdgeInsets != UIEdgeInsets.zero {
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
        for item in items {
            let itemHeight = item.itemHeight
            if itemHeight > maxItemContentHeight {
                maxItemContentHeight = itemHeight
            }
        }
        p_maxItemContentHeight = maxItemContentHeight + ZZ_TAB_BAR_SAFE_AREA_HEIGHT
        return p_maxItemContentHeight
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
        separationLine.backgroundColor = separationLineBackgroundColor
        separationLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separationLine)
        self.setupSeparationLine()
        separationLine.isHidden = !showSeparationLine
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(separationLine)
    }
    
    fileprivate var separationLineHeightConstraint: NSLayoutConstraint?
    fileprivate func setupSeparationLine() {
        let separationLineLeadingConstraint = NSLayoutConstraint(item: separationLine, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineLeadingConstraint)
        
        let separationLineTrailingConstraint = NSLayoutConstraint(item: separationLine, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineTrailingConstraint)
        
        let separationLineBottomConstraint = NSLayoutConstraint(item: separationLine, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(separationLineBottomConstraint)
        
        separationLineHeightConstraint = NSLayoutConstraint(item: separationLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
        separationLine.addConstraint(separationLineHeightConstraint!)
    }
    
    // MARK: - Configuration
    fileprivate var itemWidth:CGFloat = 0.0
    
    //MARK: - Item selection
    @objc func tabBarItemWasSelected(_ sender : ZZTabBarItem) -> Void {
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
                let idx: Int = items.index(of: sender)!
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


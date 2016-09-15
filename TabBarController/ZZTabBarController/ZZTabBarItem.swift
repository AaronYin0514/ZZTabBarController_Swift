//
//  ZZTabBarItem.swift
//  TabBarController
//
//  Created by Aaron on 16/8/19.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

enum ZZTabBarItemType {
    case normal
    case action
}

private let ZZTabBarItemImageWidth: CGFloat = 25.0
private let ZZTabBarItemBadgeWidth: CGFloat = 18.0

class ZZTabBarItem: UIControl {
    
    var itemType: ZZTabBarItemType = .normal {
        didSet {
            self.customLayoutSubviews()
        }
    }
    
    // itemHeight is an optional property. When set it is used instead of tabBar's height.
    var itemHeight:CGFloat = 49.0
    
    var index: Int?
    
    // MARK: - Title configuration
    
    // The title displayed by the tab bar item.
    var title:String? {
        didSet {
            if title != nil {
                titleLabel.text = title!
                self.customLayoutSubviews()
            }
        }
    }
    
    fileprivate var titleLabel:UILabel = UILabel()
    
    // The offset for the rectangle around the tab bar item's title.
    var titlePositionAdjustment:UIOffset = UIOffset.zero
    
    // The title attributes dictionary used for tab bar item's unselected state.
    fileprivate var p_unselectedTitleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 11.0), NSForegroundColorAttributeName : UIColor.lightGray]
    var unselectedTitleAttributes: [String : AnyObject] {
        set(value) {
            if value[NSFontAttributeName] != nil {
                p_unselectedTitleAttributes[NSFontAttributeName] = value[NSFontAttributeName]
            } else if value[NSForegroundColorAttributeName] != nil {
                p_unselectedTitleAttributes[NSForegroundColorAttributeName] = value[NSForegroundColorAttributeName]
            }
        }
        get {
            return p_unselectedTitleAttributes
        }
    }
    
    // The title attributes dictionary used for tab bar item's selected state.
    fileprivate var p_selectedTitleAttributes: [String : AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 11.0), NSForegroundColorAttributeName : UIColor.black]
    var selectedTitleAttributes: [String : AnyObject] {
        set(value) {
            if value[NSFontAttributeName] != nil {
                p_selectedTitleAttributes[NSFontAttributeName] = value[NSFontAttributeName]
            } else if value[NSForegroundColorAttributeName] != nil {
                p_selectedTitleAttributes[NSForegroundColorAttributeName] = value[NSForegroundColorAttributeName]
            }
        }
        get {
            return p_selectedTitleAttributes
        }
    }
    
    // MARK: - Image configuration
    
    // The offset for the rectangle around the tab bar item's image.
    var imagePositionAdjustment:UIOffset = UIOffset.zero;
    
    // The image used for tab bar item's selected state.
    var selectedImage:UIImage? {
        didSet {
            if selectedImage != nil && self.image == nil {
                self.customLayoutSubviews()
            }
        }
    }
    
    // The image used for tab bar item's unselected state.
    var image: UIImage? {
        didSet {
            if image != nil && self.selectedImage == nil {
                imageView.image = image
                self.customLayoutSubviews()
            }
        }
    }
    
    fileprivate var imageView: UIImageView = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                backgroundImageView.image = selectedBackgroundImage
                imageView.image = selectedImage
                titleLabel.textColor = p_selectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
                titleLabel.font = p_selectedTitleAttributes[NSFontAttributeName] as! UIFont
            } else {
                backgroundImageView.image = backgroundImage
                imageView.image = image
                titleLabel.textColor = p_unselectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
                titleLabel.font = p_unselectedTitleAttributes[NSFontAttributeName] as! UIFont
            }
        }
    }
    
    // MARK: - Background configuration
    
    // The background image used for tab bar item's selected state.
    var selectedBackgroundImage: UIImage?
    
    // The background image used for tab bar item's unselected state.
    var backgroundImage: UIImage? {
        didSet {
            if backgroundImage != nil {
                backgroundImageView.image = backgroundImage
            }
        }
    }
    
    fileprivate var backgroundImageView: UIImageView = UIImageView()
    
    // MARK: - Badge configuration
    
    // Text that is displayed in the upper-right corner of the item with a surrounding background.
    var badgeValue:String = "" {
        didSet {
            badgeLabel.setBadgeValue(badgeValue, animated: false)
            self.customLayoutSubviews()
        }
    }
    
    // Color used for badge's background.
    var badgeBackgroundColor:UIColor = UIColor.red
    
    // Color used for badge's text.
    var badgeTextColor:UIColor = UIColor.white
    
    // The offset for the rectangle around the tab bar item's badge.
    var badgePositionAdjustment:UIOffset = UIOffset.zero
    
    // Font used for badge's text.
    var badgeTextFont:UIFont = UIFont.systemFont(ofSize: 12.0)
    
    var badgeLabel: ZZBadgeLabel = ZZBadgeLabel(frame: CGRect.zero)
    
    func setBadgeValue(_ value: String, animated: Bool) -> Void {
        badgeLabel.setBadgeValue(value, animated: animated)
    }
    
    // MARK: - Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    fileprivate func commonInit() -> Void {
        self.backgroundColor = UIColor.clear
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        self.layoutBackgroundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.layoutImageView()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = p_unselectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
        titleLabel.font = p_unselectedTitleAttributes[NSFontAttributeName] as! UIFont
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        self.layoutTitleLabel()
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.text = badgeValue
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.textColor = badgeTextColor
        badgeLabel.font = badgeTextFont
        self.addSubview(badgeLabel)
    }
    
    fileprivate func layoutBackgroundImageView() {
        let backgroundImageViewLeadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        self.addConstraint(backgroundImageViewLeadingConstraint)
        
        let backgroundImageViewTrailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraint(backgroundImageViewTrailingConstraint)
        
        let backgroundImageViewTopConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(backgroundImageViewTopConstraint)
        
        let backgroundImageViewBottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraint(backgroundImageViewBottomConstraint)
    }
    
    fileprivate var imageViewHeightConstraint:NSLayoutConstraint?
    fileprivate var imageViewWidthConstraint:NSLayoutConstraint?
    fileprivate var imageViewCenterYConstraint:NSLayoutConstraint?
    fileprivate var imageViewCenterXConstraint:NSLayoutConstraint?
    
    fileprivate func layoutImageView() -> Void {
        var height: CGFloat = ZZTabBarItemImageWidth
        var width: CGFloat = ZZTabBarItemImageWidth
        if self.itemType == .action {
            if image != nil {
                height = image!.size.height
                height = height > self.itemHeight ? self.itemHeight : height
                width = image!.size.width / image!.size.height * height
            }
        }
        
        if imageViewHeightConstraint == nil {
            imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: height);
            imageView.addConstraint(imageViewHeightConstraint!)
        } else {
            imageViewHeightConstraint?.constant = height
        }
        if imageViewWidthConstraint == nil {
            imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
            imageView.addConstraint(imageViewWidthConstraint!)
        } else {
            imageViewWidthConstraint?.constant = width
        }
        if imageViewCenterYConstraint != nil {
            imageViewCenterYConstraint?.constant = (title == nil) ? imagePositionAdjustment.vertical : -(imagePositionAdjustment.vertical + 14.0 / 2)
        } else {
            imageViewCenterYConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: imagePositionAdjustment.vertical)
            self .addConstraint(imageViewCenterYConstraint!)
        }
        if imageViewCenterXConstraint != nil {
            imageViewCenterXConstraint?.constant = imagePositionAdjustment.horizontal
        } else {
            imageViewCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: imagePositionAdjustment.horizontal)
            self .addConstraint(imageViewCenterXConstraint!)
        }
    }
    
    fileprivate var titleLabelLeadingConstraint:NSLayoutConstraint?
    fileprivate var titleLabelTrailingConstraint:NSLayoutConstraint?
    fileprivate var titleLabelHeightConstraint:NSLayoutConstraint?
    fileprivate var titleLabelBottomConstraint:NSLayoutConstraint?
    
    fileprivate func layoutTitleLabel() -> Void {
        if titleLabelLeadingConstraint != nil {
            titleLabelLeadingConstraint?.constant = 0.0
        } else {
            titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            self.addConstraint(titleLabelLeadingConstraint!)
        }
        if titleLabelTrailingConstraint != nil {
            titleLabelTrailingConstraint?.constant = 0.0
        } else {
            titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            self.addConstraint(titleLabelTrailingConstraint!)
        }
        if titleLabelHeightConstraint != nil {
            titleLabelHeightConstraint?.constant = 14.0
        } else {
            titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 14.0);
            titleLabel.addConstraint(titleLabelHeightConstraint!)
        }
        if titleLabelBottomConstraint != nil {
            titleLabelBottomConstraint?.constant = -(titlePositionAdjustment.vertical + 3.0)
        } else {
            titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -(titlePositionAdjustment.vertical + 3.0))
            self.addConstraint(titleLabelBottomConstraint!)
        }
    }
    
    fileprivate var badgeLabelHeightConstraint:NSLayoutConstraint?
    fileprivate var badgeLabelWidthConstraint:NSLayoutConstraint?
    fileprivate var badgeLabelCenterYConstraint:NSLayoutConstraint?
    fileprivate var badgeLabelCenterXConstraint:NSLayoutConstraint?
    
    fileprivate func layoutbadgeLabel() -> Void {
        if itemType == .action {
            badgeLabel.isHidden = true
            return
        }
        badgeLabel.setBadgeValue(badgeValue, animated: false)
        if badgeLabelHeightConstraint == nil {
            badgeLabelHeightConstraint = NSLayoutConstraint(item: badgeLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemBadgeWidth);
            badgeLabel.addConstraint(badgeLabelHeightConstraint!)
        }
        if badgeLabelWidthConstraint == nil {
            badgeLabelWidthConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemBadgeWidth)
            badgeLabel.addConstraint(badgeLabelWidthConstraint!)
        }
        if badgeLabelCenterXConstraint == nil {
            badgeLabelCenterXConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            self .addConstraint(badgeLabelCenterXConstraint!)
        }
        if badgeLabelCenterYConstraint == nil {
            badgeLabelCenterYConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
            self .addConstraint(badgeLabelCenterYConstraint!)
        }
    }
    
    fileprivate func customLayoutSubviews() -> Void {
        self.layoutImageView()
        self.layoutTitleLabel()
        self.layoutbadgeLabel()
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

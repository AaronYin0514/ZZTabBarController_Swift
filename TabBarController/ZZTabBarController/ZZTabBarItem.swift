//
//  ZZTabBarItem.swift
//  TabBarController
//
//  Created by Aaron on 16/8/19.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

private let ZZTabBarItemImageWidth: CGFloat = 25.0

class ZZTabBarItem: UIControl {
    /// itemHeight is an optional property. When set it is used instead of tabBar's height.
    var itemHeight:CGFloat = 49.0
    
    // MARK: - Title configuration
    
    /// The title displayed by the tab bar item.
    var title:String? {
        didSet {
            if title != nil {
                titleLabel.text = title!
                self.customLayoutSubviews()
            }
        }
    }
    
    private var titleLabel:UILabel = UILabel()
    
    /// The offset for the rectangle around the tab bar item's title.
    var titlePositionAdjustment:UIOffset = UIOffsetZero
    
    /// The title attributes dictionary used for tab bar item's unselected state.
    private var p_unselectedTitleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(10.0), NSForegroundColorAttributeName : UIColor.lightGrayColor()]
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
    
    /// The title attributes dictionary used for tab bar item's selected state.
    private var p_selectedTitleAttributes: [String : AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(10.0), NSForegroundColorAttributeName : UIColor.blackColor()]
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
    
    /// The offset for the rectangle around the tab bar item's image.
    var imagePositionAdjustment:UIOffset = UIOffsetZero;
    
    /// The image used for tab bar item's selected state.
    var selectedImage:UIImage? {
        didSet {
            if selectedImage != nil && self.image == nil {
                self.customLayoutSubviews()
            }
        }
    }
    
    /// The image used for tab bar item's unselected state.
    var image: UIImage? {
        didSet {
            if image != nil && self.selectedImage == nil {
                imageView.image = image
                self.customLayoutSubviews()
            }
        }
    }
    
    private var imageView: UIImageView = UIImageView()
    
    override var selected: Bool {
        didSet {
            if selected == true {
                imageView.image = selectedImage
                titleLabel.textColor = p_selectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
                titleLabel.font = p_selectedTitleAttributes[NSFontAttributeName] as! UIFont
            } else {
                imageView.image = image
                titleLabel.textColor = p_unselectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
                titleLabel.font = p_unselectedTitleAttributes[NSFontAttributeName] as! UIFont
            }
        }
    }
    
    // MARK: - Background configuration
    
    /// The background image used for tab bar item's selected state.
    var selectedBackgroundImage: UIImage?
    
    /// The background image used for tab bar item's unselected state.
    var unselectedBackgroundImage: UIImage?
    
    // MARK: - Badge configuration
    
    /// Text that is displayed in the upper-right corner of the item with a surrounding background.
    var badgeValue:String? = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Image used for background of badge.
    var badgeBackgroundImage:UIImage?
    
    /// Color used for badge's background.
    var badgeBackgroundColor:UIColor = UIColor.redColor()
    
    /// Color used for badge's text.
    var badgeTextColor:UIColor = UIColor.whiteColor();
    
    /// The offset for the rectangle around the tab bar item's badge.
    var badgePositionAdjustment:UIOffset = UIOffsetZero
    
    /// Font used for badge's text.
    var badgeTextFont:UIFont = UIFont.systemFontOfSize(12.0)
    
    
    // MARK: - Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() -> Void {
        self.backgroundColor = UIColor.clearColor()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.layoutImageView()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = p_unselectedTitleAttributes[NSForegroundColorAttributeName] as! UIColor
        titleLabel.font = p_unselectedTitleAttributes[NSFontAttributeName] as! UIFont
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        self.layoutTitleLabel()
    }
    
    private var imageViewHeightConstraint:NSLayoutConstraint?
    private var imageViewWidthConstraint:NSLayoutConstraint?
    private var imageViewCenterYConstraint:NSLayoutConstraint?
    private var imageViewCenterXConstraint:NSLayoutConstraint?
    
    private func layoutImageView() -> Void {
        if imageViewHeightConstraint == nil {
            imageViewHeightConstraint = NSLayoutConstraint.init(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: ZZTabBarItemImageWidth);
            imageView.addConstraint(imageViewHeightConstraint!)
        }
        if imageViewWidthConstraint == nil {
            imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: ZZTabBarItemImageWidth)
            imageView.addConstraint(imageViewWidthConstraint!)
        }
        if imageViewCenterYConstraint != nil {
            imageViewCenterYConstraint?.constant = (title == nil) ? imagePositionAdjustment.vertical : -(imagePositionAdjustment.vertical + 14.0 / 2)
        } else {
            imageViewCenterYConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: imagePositionAdjustment.vertical)
            self .addConstraint(imageViewCenterYConstraint!)
        }
        if imageViewCenterXConstraint != nil {
            imageViewCenterXConstraint?.constant = imagePositionAdjustment.horizontal
        } else {
            imageViewCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: imagePositionAdjustment.horizontal)
            self .addConstraint(imageViewCenterXConstraint!)
        }
    }
    
    private var titleLabelLeadingConstraint:NSLayoutConstraint?
    private var titleLabelTrailingConstraint:NSLayoutConstraint?
    private var titleLabelHeightConstraint:NSLayoutConstraint?
    private var titleLabelBottomConstraint:NSLayoutConstraint?
    
    private func layoutTitleLabel() -> Void {
        if titleLabelLeadingConstraint != nil {
            titleLabelLeadingConstraint?.constant = 0.0
        } else {
            titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
            self.addConstraint(titleLabelLeadingConstraint!)
        }
        if titleLabelTrailingConstraint != nil {
            titleLabelTrailingConstraint?.constant = 0.0
        } else {
            titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
            self.addConstraint(titleLabelTrailingConstraint!)
        }
        if titleLabelHeightConstraint != nil {
            titleLabelHeightConstraint?.constant = 14.0
        } else {
            titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 14.0);
            titleLabel.addConstraint(titleLabelHeightConstraint!)
        }
        if titleLabelBottomConstraint != nil {
            titleLabelBottomConstraint?.constant = -(titlePositionAdjustment.vertical + 3.0)
        } else {
            titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -(titlePositionAdjustment.vertical + 3.0))
            self.addConstraint(titleLabelBottomConstraint!)
        }
    }
    
    private func customLayoutSubviews() -> Void {
        self.layoutImageView()
        self.layoutTitleLabel()
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

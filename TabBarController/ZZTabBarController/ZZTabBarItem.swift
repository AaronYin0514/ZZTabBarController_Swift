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

class ZZTabBarItem: UIView {
    
    var itemType: ZZTabBarItemType = .normal {
        didSet {
            updateAutoLayout()
        }
    }
    
    // itemHeight is an optional property. When set it is used instead of tabBar's height.
    var itemHeight: CGFloat = 49.0
    
    var imageWidth: CGFloat = ZZTabBarItemImageWidth {
        didSet {
            updateAutoLayout()
        }
    }
    var imageHeight: CGFloat = ZZTabBarItemImageWidth {
        didSet {
            updateAutoLayout()
        }
    }
    
    var index: Int?
    
    // MARK: - Title configuration
    
    // The title displayed by the tab bar item.
    var title:String? {
        didSet {
            titleLabel.text = title
            updateAutoLayout()
        }
    }
    
    fileprivate var titleLabel:UILabel = UILabel()
    
    // The offset for the rectangle around the tab bar item's title.
    var titlePositionAdjustment:UIOffset = UIOffset.zero
    
    // The title attributes dictionary used for tab bar item's unselected state.
    fileprivate var p_unselectedTitleAttributes : [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
    var unselectedTitleAttributes: [NSAttributedString.Key : AnyObject] {
        
        set(value) {
            if value[NSAttributedString.Key.font] != nil {
                p_unselectedTitleAttributes[NSAttributedString.Key.font] = value[NSAttributedString.Key.font]
            } else if value[NSAttributedString.Key.foregroundColor] != nil {
                p_unselectedTitleAttributes[NSAttributedString.Key.foregroundColor] = value[NSAttributedString.Key.foregroundColor]
            }
        }
        get {
            return p_unselectedTitleAttributes
        }
    }
    
    // The title attributes dictionary used for tab bar item's selected state.
    fileprivate var p_selectedTitleAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0), NSAttributedString.Key.foregroundColor : UIColor.black]
    var selectedTitleAttributes: [NSAttributedString.Key : AnyObject] {
        set(value) {
            if value[NSAttributedString.Key.font] != nil {
                p_selectedTitleAttributes[NSAttributedString.Key.font] = value[NSAttributedString.Key.font]
            } else if value[NSAttributedString.Key.foregroundColor] != nil {
                p_selectedTitleAttributes[NSAttributedString.Key.foregroundColor] = value[NSAttributedString.Key.foregroundColor]
            }
        }
        get {
            return p_selectedTitleAttributes
        }
    }
    
    // MARK: - Image configuration
    
    // The offset for the rectangle around the tab bar item's image.
    var imagePositionAdjustment:UIOffset = UIOffset.zero {
        didSet {
            updateAutoLayout()
        }
    }
    
    // The image used for tab bar item's selected state.
    var selectedImage:UIImage? {
        didSet {
            if selectedImage != nil && self.image == nil {
                updateAutoLayout()
            }
        }
    }
    
    // The image used for tab bar item's unselected state.
    var image: UIImage? {
        didSet {
            if image != nil && self.selectedImage == nil {
                imageView.image = image
                updateAutoLayout()
            }
        }
    }
    
    fileprivate var imageView: UIImageView = UIImageView()
    
    var isSelected: Bool = false {
        didSet {
            if isSelected == true {
                backgroundImageView.image = selectedBackgroundImage
                imageView.image = selectedImage
                titleLabel.textColor = p_selectedTitleAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
                titleLabel.font = p_selectedTitleAttributes[NSAttributedString.Key.font] as? UIFont
            } else {
                backgroundImageView.image = backgroundImage
                imageView.image = image
                titleLabel.textColor = p_unselectedTitleAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
                titleLabel.font = p_unselectedTitleAttributes[NSAttributedString.Key.font] as? UIFont
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
            updateAutoLayout()
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
        addSubview(backgroundImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = p_unselectedTitleAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        titleLabel.font = p_unselectedTitleAttributes[NSAttributedString.Key.font] as? UIFont
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.text = badgeValue
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.textColor = badgeTextColor
        badgeLabel.font = badgeTextFont
        addSubview(badgeLabel)
        addAutoLayoutSubviews()
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
    
    fileprivate lazy var imageViewHeightConstraint:NSLayoutConstraint = {
        let imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemImageWidth);
        return imageViewHeightConstraint
    }()
    fileprivate lazy var imageViewWidthConstraint:NSLayoutConstraint = {
        let imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemImageWidth)
        return imageViewWidthConstraint
    }()
    fileprivate lazy var imageViewCenterYConstraint:NSLayoutConstraint = {
        let vertical: CGFloat = (title?.isEmpty ?? true) ? imagePositionAdjustment.vertical : -(-imagePositionAdjustment.vertical + 14.0 / 2)
        let imageViewCenterYConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: vertical)
        return imageViewCenterYConstraint
    }()
    fileprivate lazy var imageViewCenterXConstraint:NSLayoutConstraint = {
        let imageViewCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: imagePositionAdjustment.horizontal)
        return imageViewCenterXConstraint
    }()
    
    fileprivate func layoutImageView() -> Void {
        var width: CGFloat = ZZTabBarItemImageWidth
        var height: CGFloat = ZZTabBarItemImageWidth
        if itemType == .action {
            width = imageWidth
            height = imageHeight
            if height > itemHeight {
                width = width / height * itemHeight
                height = itemHeight
            }
        }
        imageViewHeightConstraint.constant = height
        imageViewWidthConstraint.constant = width
        imageView.addConstraint(imageViewHeightConstraint)
        imageView.addConstraint(imageViewWidthConstraint)
        addConstraint(imageViewCenterYConstraint)
        addConstraint(imageViewCenterXConstraint)
    }
    
    fileprivate lazy var titleLabelLeadingConstraint:NSLayoutConstraint = {
        let titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        return titleLabelLeadingConstraint
    }()
    fileprivate lazy var titleLabelTrailingConstraint:NSLayoutConstraint = {
        let titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        return titleLabelTrailingConstraint
    }()
    fileprivate lazy var titleLabelHeightConstraint:NSLayoutConstraint = {
        let titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 14.0)
        return titleLabelHeightConstraint
    }()
    fileprivate lazy var titleLabelTopConstraint:NSLayoutConstraint = {
        let titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: (titlePositionAdjustment.vertical + 2.0))
        return titleLabelBottomConstraint
    }()
    
    fileprivate func layoutTitleLabel() -> Void {
        addConstraint(titleLabelLeadingConstraint)
        addConstraint(titleLabelTrailingConstraint)
        titleLabel.addConstraint(titleLabelHeightConstraint)
        addConstraint(titleLabelTopConstraint)
    }
    
    fileprivate lazy var badgeLabelHeightConstraint:NSLayoutConstraint = {
        let badgeLabelHeightConstraint = NSLayoutConstraint(item: badgeLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemBadgeWidth)
        return badgeLabelHeightConstraint
    }()
    fileprivate lazy var badgeLabelWidthConstraint:NSLayoutConstraint = {
        let badgeLabelWidthConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: ZZTabBarItemBadgeWidth)
        return badgeLabelWidthConstraint
    }()
    fileprivate lazy var badgeLabelCenterYConstraint:NSLayoutConstraint = {
        let badgeLabelCenterXConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        return badgeLabelCenterXConstraint
    }()
    fileprivate lazy var badgeLabelCenterXConstraint:NSLayoutConstraint = {
        let badgeLabelCenterYConstraint = NSLayoutConstraint(item: badgeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        return badgeLabelCenterYConstraint
    }()
    
    fileprivate func layoutbadgeLabel() -> Void {
        if itemType == .action {
            badgeLabel.isHidden = true
            return
        }
        badgeLabel.setBadgeValue(badgeValue, animated: false)
        badgeLabel.addConstraint(badgeLabelHeightConstraint)
        badgeLabel.addConstraint(badgeLabelWidthConstraint)
        addConstraint(badgeLabelCenterYConstraint)
        addConstraint(badgeLabelCenterXConstraint)
    }
    
    fileprivate func addAutoLayoutSubviews() -> Void {
        self.layoutImageView()
        self.layoutTitleLabel()
        self.layoutbadgeLabel()
        self.setNeedsLayout()
    }
    
    fileprivate func updateAutoLayout() {
        imageViewCenterYConstraint.constant = (title?.isEmpty ?? true) ? imagePositionAdjustment.vertical : -(-imagePositionAdjustment.vertical + 14.0 / 2)
        var width: CGFloat = ZZTabBarItemImageWidth
        var height: CGFloat = ZZTabBarItemImageWidth
        if itemType == .action {
            width = imageWidth
            height = imageHeight
            if height > itemHeight {
                width = width / height * itemHeight
                height = itemHeight
            }
        }
        imageViewHeightConstraint.constant = height
        imageViewWidthConstraint.constant = width
        setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


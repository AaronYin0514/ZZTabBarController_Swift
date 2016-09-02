//
//  ZZTabBarItem.swift
//  TabBarController
//
//  Created by Aaron on 16/8/19.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZTabBarItem: UIControl {
    /// itemHeight is an optional property. When set it is used instead of tabBar's height.
    var itemHeight:CGFloat = 49.0
    
    // MARK: - Title configuration
    
    /// The title displayed by the tab bar item.
    var title:String? {
        didSet {
            if title != nil {
                titleLabel.text = title!
                self.layoutIfNeeded()
            }
        }
    }
    
    private var titleLabel:UILabel = UILabel()
    
    /// The offset for the rectangle around the tab bar item's title.
    var titlePositionAdjustment:UIOffset = UIOffsetZero
    
    /// The title attributes dictionary used for tab bar item's unselected state.
    var unselectedTitleAttributes: [String : AnyObject]?
    
    /// The title attributes dictionary used for tab bar item's selected state.
    var selectedTitleAttributes: [String : AnyObject]?
    
    // MARK: - Image configuration
    
    /// The offset for the rectangle around the tab bar item's image.
    var imagePositionAdjustment:UIOffset = UIOffsetZero;
    
    /// The image used for tab bar item's selected state.
    var selectedImage:UIImage? {
        didSet {
            if selectedImage != nil && self.image == nil {
                self.layoutIfNeeded()
            }
        }
    }
    
    /// The image used for tab bar item's unselected state.
    var image: UIImage? {
        didSet {
            if image != nil && self.selectedImage == nil {
                imageView.image = image
                self.layoutIfNeeded()
            }
        }
    }
    
    private var imageView: UIImageView = UIImageView()
    
    override var selected: Bool {
        didSet {
            if selected == true {
                imageView.image = selectedImage
            } else {
                imageView.image = image
            }
        }
    }
    
    /**
     Sets the tab bar item's selected and unselected images.
     
     - parameter selectedImage:   selectedImage
     - parameter unSelectedImage: unSelectedImage
     */
    func setSelectedImage(selectedImage:UIImage, image:UIImage) -> Void {
        self.selectedImage = selectedImage;
        self.image = image;
    }
    
    // MARK: - Background configuration
    
    /// The background image used for tab bar item's selected state.
    var selectedBackgroundImage: UIImage?
    
    /// The background image used for tab bar item's unselected state.
    var unselectedBackgroundImage: UIImage?
    
    /**
     Sets the tab bar item's selected and unselected background images.
     
     - parameter selectedImage:   background selectedImage
     - parameter unSelectedImage: background unSelectedImage
     */
    func setBackgroundSelectedImage(selectedImage:UIImage, unSelectedImage:UIImage) -> Void {
        self.selectedBackgroundImage = selectedImage;
        self.unselectedBackgroundImage = unSelectedImage;
    }
    
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
    
    func commonInit() -> Void {
        self.backgroundColor = UIColor.clearColor()
        unselectedTitleAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName : UIColor.blackColor()]
        selectedTitleAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName : UIColor.blackColor()]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.layoutImageView()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(13.0)
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        self.layoutTitleLabel()
    }
    
    private var imageViewHeightConstraint:NSLayoutConstraint?
    private var imageViewWidthConstraint:NSLayoutConstraint?
    private var imageViewCenterYConstraint:NSLayoutConstraint?
    private var imageViewCenterXConstraint:NSLayoutConstraint?
    
    private func layoutImageView() -> Void {
        imageViewHeightConstraint = NSLayoutConstraint.init(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 25.0);
        imageView.addConstraint(imageViewHeightConstraint!)
        
        imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
        imageView.addConstraint(imageViewWidthConstraint!);
        
        imageViewCenterYConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: imagePositionAdjustment.vertical)
        self .addConstraint(imageViewCenterYConstraint!)
        
        imageViewCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: imagePositionAdjustment.horizontal)
        self .addConstraint(imageViewCenterXConstraint!)
    }
    
    private var titleLabelLeadingConstraint:NSLayoutConstraint?
    private var titleLabelTrailingConstraint:NSLayoutConstraint?
    private var titleLabelHeightConstraint:NSLayoutConstraint?
    private var titleLabelBottomConstraint:NSLayoutConstraint?
    
    private func layoutTitleLabel() -> Void {
        titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        self.addConstraint(titleLabelLeadingConstraint!)
        
        titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraint(titleLabelTrailingConstraint!)
        
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 18.0);
        titleLabel.addConstraint(titleLabelHeightConstraint!)
        
        titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: titlePositionAdjustment.vertical)
        self.addConstraint(titleLabelBottomConstraint!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleIsNil:Bool = title == nil
        let imageIsNil:Bool = (image == nil && selectedImage == nil);
        if titleIsNil == false && imageIsNil == true {
            
        } else if titleIsNil == true && imageIsNil == false {
            
        } else if titleIsNil == false && imageIsNil == false {
            
        }
    }
}

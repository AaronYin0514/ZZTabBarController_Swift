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
    var itemHeight:CGFloat = 0.0
    
    // MARK: - Title configuration
    
    /// The title displayed by the tab bar item.
    var title:String?
    
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
    var selectedImage:UIImage?
    
    /// The image used for tab bar item's unselected state.
    var unselectedImage: UIImage?
    
    /**
     Sets the tab bar item's selected and unselected images.
     
     - parameter selectedImage:   selectedImage
     - parameter unSelectedImage: unSelectedImage
     */
    func setSelectedImage(selectedImage:UIImage, unSelectedImage:UIImage) -> Void {
        self.selectedImage = selectedImage;
        self.unselectedImage = unSelectedImage;
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
    
    // MARK - Badge configuration
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() -> Void {
        self.backgroundColor = UIColor.clearColor()
        unselectedTitleAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName : UIColor.blackColor()]
        selectedTitleAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName : UIColor.blackColor()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func drawRect(rect: CGRect) {
        let frameSize: CGSize = self.frame.size
        var imageSize: CGSize = CGSizeZero
        var titleSize: CGSize = CGSizeZero
        var titleAttributes:[String : AnyObject]?
        var backgroundImage: UIImage?
        var image: UIImage?
        var imageStartingY: CGFloat = 0.0
        
        if self.selected {
            image = self.selectedImage
            backgroundImage = self.selectedBackgroundImage
            titleAttributes = self.selectedTitleAttributes
        } else {
            image = self.unselectedImage
            backgroundImage = self.unselectedBackgroundImage
            titleAttributes = self.unselectedTitleAttributes
        }
        
        if image?.size != nil {
            imageSize = (image?.size)!
        }
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        
        backgroundImage?.drawInRect(self.bounds)
        
        // Draw image and title
        if title == nil {
            let rect = CGRectMake(ZZMathUtils.CGRoundf(frameSize.width / 2 - imageSize.width / 2) + imagePositionAdjustment.horizontal, ZZMathUtils.CGRoundf(frameSize.height / 2 - imageSize.height / 2) + imagePositionAdjustment.vertical, imageSize.width, imageSize.height)
            image?.drawInRect(rect)
        } else {
            let nsTitle = NSString(string: title!)
            titleSize = nsTitle.boundingRectWithSize(CGSizeMake(frameSize.width, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleAttributes, context: nil).size
            imageStartingY = ZZMathUtils.CGRoundf((frameSize.height - imageSize.height - titleSize.height) / 2)
            let rect = CGRectMake(ZZMathUtils.CGRoundf(frameSize.width / 2 - imageSize.width / 2) + imagePositionAdjustment.horizontal, imageStartingY + imagePositionAdjustment.vertical, imageSize.width, imageSize.height)
            image?.drawInRect(rect)
            
            CGContextSetFillColorWithColor(context, titleAttributes![NSForegroundColorAttributeName]?.CGColor)
            
            let titleRect = CGRectMake(ZZMathUtils.CGRoundf(frameSize.width / 2 - titleSize.width / 2) + titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + titlePositionAdjustment.vertical, titleSize.width, titleSize.height)
            nsTitle.drawInRect(titleRect, withAttributes: titleAttributes)
        }
        
        // Draw badges
        
        let nsBadgeValue = NSString(string: self.badgeValue!)
        
        if nsBadgeValue.integerValue != 0 {
            var badgeSize = nsBadgeValue.boundingRectWithSize(CGSizeMake(frameSize.width, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.badgeTextFont], context: nil).size
            let textOffset:CGFloat = 2.0
            
            if (badgeSize.width < badgeSize.height) {
                badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
            }
            
            let badgeBackgroundFrame = CGRectMake(ZZMathUtils.CGRoundf(frameSize.width / 2 + (image!.size.width / 2) * 0.9) + badgePositionAdjustment.horizontal, textOffset + badgePositionAdjustment.vertical, badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
            
            if badgeBackgroundImage != nil {
                badgeBackgroundImage?.drawInRect(badgeBackgroundFrame)
            } else {
                CGContextSetFillColorWithColor(context, badgeBackgroundColor.CGColor)
                CGContextFillEllipseInRect(context, badgeBackgroundFrame)
            }
            
            CGContextSetFillColorWithColor(context, badgeTextColor.CGColor)
            
            let badgeTextStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
            badgeTextStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            badgeTextStyle.alignment = NSTextAlignment.Center
            let badgeTextAttributes:[String : AnyObject] = [NSFontAttributeName : badgeTextFont, NSForegroundColorAttributeName : badgeTextColor, NSParagraphStyleAttributeName : badgeTextStyle];
            let badgeRect = CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset, CGRectGetMinY(badgeBackgroundFrame) + textOffset, badgeSize.width, badgeSize.height);
            nsBadgeValue.drawInRect(badgeRect, withAttributes: badgeTextAttributes)
            
        }
        
        CGContextRestoreGState(context);
    }
    
}

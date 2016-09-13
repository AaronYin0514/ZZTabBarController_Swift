//
//  ZZBadgeLabel.swift
//  TabBarController
//
//  Created by Aaron on 16/9/13.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZBadgeLabel: UILabel {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Method
    func setBadgeValue(value: String, animated: Bool) -> Void {
        let num = Int(value)
        if num == nil || num <= 0 {
            self.hidden = true
            return
        }
        if num > 99 {
            self.text = "99"
        } else {
            self.text = value
        }
        self.hidden = false
        if animated {
            self.zoomIn(self)
        }
    }
    
    // MARK: - Utils
    private func zoomIn(view: UIView) -> Void {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.5
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        var values: [NSValue] = []
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        view.layer.addAnimation(animation, forKey: nil)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

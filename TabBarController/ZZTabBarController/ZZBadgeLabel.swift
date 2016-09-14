//
//  ZZBadgeLabel.swift
//  TabBarController
//
//  Created by Aaron on 16/9/13.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZBadgeLabel: UILabel {
    
    // MARK: - Private Property
    private var windowView: UIView?
    private var frontLabel: UILabel?
    private var behindView: UIView?
    
    private var springRange: CGFloat = 5.0 // 弹簧效果幅度，值越大，幅度越大，默认为5.0
    private var ratio: CGFloat = 0.15 // 默认拉伸长度比率
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    private var miniRad: CGFloat = 4.0
    private var r1: CGFloat = 0.0
    private var r2: CGFloat = 0.0
    private var orgialPoint: CGPoint = CGPointZero
    private var pointA: CGPoint = CGPointZero
    private var pointB: CGPoint = CGPointZero
    private var pointC: CGPoint = CGPointZero
    private var pointD: CGPoint = CGPointZero
    private var pointO: CGPoint = CGPointZero
    private var pointP: CGPoint = CGPointZero
    private var pointG: CGPoint = CGPointZero
    private var x1: CGFloat = 0.0
    private var x2: CGFloat = 0.0
    private var y1: CGFloat = 0.0
    private var y2: CGFloat = 0.0
    private var sin: CGFloat = 0.0
    private var cos: CGFloat = 0.0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .Center
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 18.0 / 2
        self.userInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ZZBadgeLabel.panGestureAction(_:)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Method
    func setBadgeValue(value: String, animated: Bool) -> Void {
        let num = Int(value)
        if num == nil || num <= 0 {
            self.text = nil
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
    
    // MARK: - Action
    // MARK: 拖动手势
    func panGestureAction(sender: UIGestureRecognizer) -> Void {
        let touchPoint = sender.locationInView(self)
        var windowTouchPoint = CGPointZero
        if windowView != nil {
            windowTouchPoint = self.convertPoint(touchPoint, toView: windowView!)
        }
        switch sender.state {
        case .Began:
            self.beginDrag(self.center)
        case .Changed:
            self.dragMovingWitTouchPoint(windowTouchPoint)
        case .Ended:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        case .Failed:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        case .Cancelled:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        default:
            break
        }
    }
    
    private func beginDrag(point: CGPoint) -> Void {
        self.hidden = true
        
        windowView = UIView(frame: UIScreen.mainScreen().bounds)
        windowView!.backgroundColor = UIColor.clearColor()
        windowView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let windowTouchPoint = self.superview!.convertPoint(point, toView: windowView!)
        orgialPoint = windowTouchPoint
        
        frontLabel = UILabel(frame: self.bounds)
        frontLabel?.textAlignment = .Center
        frontLabel?.backgroundColor = self.backgroundColor
        frontLabel?.text = self.text
        frontLabel?.textColor = self.textColor
        frontLabel?.font = self.font
        frontLabel?.userInteractionEnabled = true
        frontLabel?.layer.masksToBounds = true
        frontLabel?.layer.cornerRadius = 18.0 / 2
        frontLabel?.center = windowTouchPoint
        
        behindView = UIView(frame: self.bounds)
        behindView?.backgroundColor = self.backgroundColor
        behindView?.layer.cornerRadius = 18.0 / 2
        behindView?.center = windowTouchPoint
        
        windowView!.addSubview(behindView!)
        windowView!.addSubview(frontLabel!)
        
        for window in UIApplication.sharedApplication().windows {
            let windowOnMainScreen = (window.screen == UIScreen.mainScreen())
            let windowIsVisible = ((window.hidden == false) && (window.alpha > 0))
            let windowLevelNormal = (window.windowLevel == UIWindowLevelNormal)
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                window.addSubview(windowView!)
                break
            }
        }
    }
    
    private func dragMovingWitTouchPoint(point: CGPoint) -> Void {
        frontLabel?.center = point
        
        if r1 < miniRad {
            behindView?.hidden = true
            shapeLayer.removeFromSuperlayer()
        } else {
            behindView?.hidden = false
        }
        
        x1 = orgialPoint.x
        y1 = orgialPoint.y
        x2 = point.x
        y2 = point.y
        let distance = CGFloat(sqrtf(Float((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))))
        if distance == 0 {
            sin = 0.0
            cos = 1.0
        } else {
            sin = (x2 - x1) / distance
            cos = (y2 - y1) / distance
        }
        r2 = frontLabel!.frame.size.height * 0.5
        r1 = r2 - distance * ratio
        pointA = CGPointMake(x1 - r1 * cos, y1 + r1 * sin)
        pointB = CGPointMake(x1 + r1 * cos , y1 - r1 * sin)
        pointC = CGPointMake(x2 + r2 * cos, y2 - r2 * sin)
        pointD = CGPointMake(x2 - r2 * cos, y2 + r2 * sin)
        pointP = CGPointMake(pointB.x + distance * 0.5 * sin, pointB.y + distance * 0.5 * cos)
        pointO = CGPointMake(pointA.x + distance * 0.5 * sin, pointA.y + distance * 0.5 * cos)
        pointG = CGPointMake(x1 + springRange * sin, y1 + springRange * cos)
        
        behindView?.bounds = CGRectMake(0, 0, r1 * 2, r1 * 2)
        behindView?.layer.cornerRadius = r1
        
        self.draw()
    }
    
    private func dragFinishWithTouchPoint(point: CGPoint) -> Void {
        if windowView != nil {
            if r1 >= miniRad {
                self.displaySpringAnimation()
            }
            if r1 < miniRad {
                frontLabel?.hidden = true
                self.setBadgeValue("", animated: false)
                self.displayBomAnimationWithPoint(point)
            }
        }
    }
    
    // MARK: - Utils
    private func draw() {
        let path = UIBezierPath()
        path.moveToPoint(pointA)
        path.addQuadCurveToPoint(pointD, controlPoint: pointO)
        path.addLineToPoint(pointC)
        path.addQuadCurveToPoint(pointB, controlPoint: pointP)
        path.moveToPoint(pointA)
        if behindView?.hidden == false {
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = self.backgroundColor?.CGColor
            windowView!.layer.insertSublayer(shapeLayer, below: frontLabel?.layer)
        }
    }
    
    private func removeWindowView() {
        if frontLabel != nil {
            frontLabel?.removeFromSuperview()
            frontLabel = nil
        }
        if behindView != nil {
            behindView?.removeFromSuperview()
            behindView = nil
        }
        windowView!.removeFromSuperview()
        windowView = nil
    }
    
    // MARK: - Animation
    // MARK: 缩放动画
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
    // MARK: 弹簧动画
    private func displaySpringAnimation() {
        weak var weakSelf = self
        shapeLayer.removeFromSuperlayer()
        behindView?.hidden = true
        let springAnimation = CASpringAnimation(keyPath: "position")
        springAnimation.stiffness = 1000
        springAnimation.damping = 5
        springAnimation.mass = 0.5
        springAnimation.initialVelocity = 70
        springAnimation.fromValue = NSValue(CGPoint: pointG)
        springAnimation.toValue = NSValue(CGPoint: orgialPoint)
        springAnimation.repeatCount = 1
        springAnimation.fillMode = kCAFillModeForwards
        springAnimation.delegate = weakSelf
        frontLabel?.layer.addAnimation(springAnimation, forKey: nil)
    }
    // MARK: 爆炸动画
    private func displayBomAnimationWithPoint(point: CGPoint) {
        shapeLayer.removeFromSuperlayer()
        behindView?.hidden = true
        let bomView = UIImageView(frame: CGRectMake(0.0, 0.0, 34.0, 34.0))
        bomView.center = point
        windowView!.addSubview(bomView)
        var bomArry: [UIImage] = []
        for i in 0..<5 {
            let imageName = String(format: "ZZTabBarBomb.bundle/bomb%ld", i)
            let image = UIImage(named: imageName)
            if image != nil {
                bomArry.append(image!)
            }
        }
        bomView.animationImages = bomArry
        bomView.animationDuration = 0.5
        bomView.animationRepeatCount = 1
        bomView.startAnimating()
        weak var weakSelf = self
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(USEC_PER_SEC * 500))
        dispatch_after(time, dispatch_get_main_queue()) {
            weakSelf?.removeWindowView()
        }
    }
    
    // Animation Delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.hidden = false
        self.removeWindowView()
    }
}

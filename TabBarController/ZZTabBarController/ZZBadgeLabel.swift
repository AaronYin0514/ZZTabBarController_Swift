//
//  ZZBadgeLabel.swift
//  TabBarController
//
//  Created by Aaron on 16/9/13.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZBadgeLabel: UILabel, CAAnimationDelegate {
    
    // MARK: - Property
    var animation: Bool = false
    
    // MARK: - Private Property
    fileprivate var windowView: UIView?
    fileprivate var frontLabel: UILabel?
    fileprivate var behindView: UIView?
    
    fileprivate var springRange: CGFloat = 5.0 // 弹簧效果幅度，值越大，幅度越大，默认为5.0
    fileprivate var ratio: CGFloat = 0.15 // 默认拉伸长度比率
    
    fileprivate var shapeLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var miniRad: CGFloat = 4.0
    fileprivate var r1: CGFloat = 0.0
    fileprivate var r2: CGFloat = 0.0
    fileprivate var orgialPoint: CGPoint = CGPoint.zero
    fileprivate var pointA: CGPoint = CGPoint.zero
    fileprivate var pointB: CGPoint = CGPoint.zero
    fileprivate var pointC: CGPoint = CGPoint.zero
    fileprivate var pointD: CGPoint = CGPoint.zero
    fileprivate var pointO: CGPoint = CGPoint.zero
    fileprivate var pointP: CGPoint = CGPoint.zero
    fileprivate var pointG: CGPoint = CGPoint.zero
    fileprivate var x1: CGFloat = 0.0
    fileprivate var x2: CGFloat = 0.0
    fileprivate var y1: CGFloat = 0.0
    fileprivate var y2: CGFloat = 0.0
    fileprivate var sin: CGFloat = 0.0
    fileprivate var cos: CGFloat = 0.0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 18.0 / 2
        self.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ZZBadgeLabel.panGestureAction(_:)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Method
    func setBadgeValue(_ value: String, animated: Bool) -> Void {
        let num = Int(value)
        if num == nil || num! <= 0 {
            self.text = nil
            self.isHidden = true
            return
        }
        if num! > 99 {
            self.text = "99"
        } else {
            self.text = value
        }
        self.isHidden = false
        if animated {
            self.zoomIn(self)
        }
    }
    
    // MARK: - Action
    // MARK: 拖动手势
    @objc func panGestureAction(_ sender: UIGestureRecognizer) -> Void {
        if animation == false {
            return
        }
        let touchPoint = sender.location(in: self)
        var windowTouchPoint = CGPoint.zero
        if windowView != nil {
            windowTouchPoint = self.convert(touchPoint, to: windowView!)
        }
        switch sender.state {
        case .began:
            self.beginDrag(self.center)
        case .changed:
            self.dragMovingWitTouchPoint(windowTouchPoint)
        case .ended:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        case .failed:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        case .cancelled:
            self.dragFinishWithTouchPoint(windowTouchPoint)
        default:
            break
        }
    }
    
    fileprivate func beginDrag(_ point: CGPoint) -> Void {
        self.isHidden = true
        
        windowView = UIView(frame: UIScreen.main.bounds)
        windowView!.backgroundColor = UIColor.clear
        windowView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let windowTouchPoint = self.superview!.convert(point, to: windowView!)
        orgialPoint = windowTouchPoint
        
        frontLabel = UILabel(frame: self.bounds)
        frontLabel?.textAlignment = .center
        frontLabel?.backgroundColor = self.backgroundColor
        frontLabel?.text = self.text
        frontLabel?.textColor = self.textColor
        frontLabel?.font = self.font
        frontLabel?.isUserInteractionEnabled = true
        frontLabel?.layer.masksToBounds = true
        frontLabel?.layer.cornerRadius = 18.0 / 2
        frontLabel?.center = windowTouchPoint
        
        behindView = UIView(frame: self.bounds)
        behindView?.backgroundColor = self.backgroundColor
        behindView?.layer.cornerRadius = 18.0 / 2
        behindView?.center = windowTouchPoint
        
        windowView!.addSubview(behindView!)
        windowView!.addSubview(frontLabel!)
        
        for window in UIApplication.shared.windows {
            let windowOnMainScreen = (window.screen == UIScreen.main)
            let windowIsVisible = ((window.isHidden == false) && (window.alpha > 0))
            let windowLevelNormal = (window.windowLevel == UIWindow.Level.normal)
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                window.addSubview(windowView!)
                break
            }
        }
    }
    
    fileprivate func dragMovingWitTouchPoint(_ point: CGPoint) -> Void {
        frontLabel?.center = point
        
        if r1 < miniRad {
            behindView?.isHidden = true
            shapeLayer.removeFromSuperlayer()
        } else {
            behindView?.isHidden = false
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
        pointA = CGPoint(x: x1 - r1 * cos, y: y1 + r1 * sin)
        pointB = CGPoint(x: x1 + r1 * cos , y: y1 - r1 * sin)
        pointC = CGPoint(x: x2 + r2 * cos, y: y2 - r2 * sin)
        pointD = CGPoint(x: x2 - r2 * cos, y: y2 + r2 * sin)
        pointP = CGPoint(x: pointB.x + distance * 0.5 * sin, y: pointB.y + distance * 0.5 * cos)
        pointO = CGPoint(x: pointA.x + distance * 0.5 * sin, y: pointA.y + distance * 0.5 * cos)
        pointG = CGPoint(x: x1 + springRange * sin, y: y1 + springRange * cos)
        
        behindView?.bounds = CGRect(x: 0, y: 0, width: r1 * 2, height: r1 * 2)
        behindView?.layer.cornerRadius = r1
        
        self.draw()
    }
    
    fileprivate func dragFinishWithTouchPoint(_ point: CGPoint) -> Void {
        if windowView != nil {
            if r1 >= miniRad {
                self.displaySpringAnimation()
            }
            if r1 < miniRad {
                frontLabel?.isHidden = true
                self.setBadgeValue("", animated: false)
                self.displayBomAnimationWithPoint(point)
            }
        }
    }
    
    // MARK: - Utils
    fileprivate func draw() {
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addQuadCurve(to: pointD, controlPoint: pointO)
        path.addLine(to: pointC)
        path.addQuadCurve(to: pointB, controlPoint: pointP)
        path.move(to: pointA)
        if behindView?.isHidden == false {
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = self.backgroundColor?.cgColor
            windowView!.layer.insertSublayer(shapeLayer, below: frontLabel?.layer)
        }
    }
    
    fileprivate func removeWindowView() {
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
    fileprivate func zoomIn(_ view: UIView) -> Void {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        var values: [NSValue] = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
    // MARK: 弹簧动画
    fileprivate func displaySpringAnimation() {
        shapeLayer.removeFromSuperlayer()
        behindView?.isHidden = true
        let springAnimation = CASpringAnimation(keyPath: "position")
        springAnimation.stiffness = 1000
        springAnimation.damping = 5
        springAnimation.mass = 0.5
        springAnimation.initialVelocity = 70
        springAnimation.fromValue = NSValue(cgPoint: pointG)
        springAnimation.toValue = NSValue(cgPoint: orgialPoint)
        springAnimation.repeatCount = 1
        springAnimation.fillMode = CAMediaTimingFillMode.forwards
        springAnimation.delegate = self
        frontLabel?.layer.add(springAnimation, forKey: nil)
    }
    // MARK: 爆炸动画
    fileprivate func displayBomAnimationWithPoint(_ point: CGPoint) {
        shapeLayer.removeFromSuperlayer()
        behindView?.isHidden = true
        let bomView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 34.0, height: 34.0))
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
        let time = DispatchTime.now() + Double(Int64(USEC_PER_SEC * 500)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            weakSelf?.removeWindowView()
            weak var tabBarItem: ZZTabBarItem? = self.superview as? ZZTabBarItem
            if tabBarItem != nil && tabBarItem!.index != nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "com.zz.tabBarController.badgeClear"), object: NSNumber(value: tabBarItem!.index! as Int))
            }
        }
    }
    
    // MARK: Animation Delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isHidden = false
        self.removeWindowView()
    }
}

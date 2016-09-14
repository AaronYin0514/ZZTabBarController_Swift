//
//  ZZBadgeView.swift
//  TabBarController
//
//  Created by Aaron on 16/9/13.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class ZZBadgeView: UIView {
    // MARK: - Property
    
    var text: String? {
        didSet {
            if text != nil {
                badgeLabel.text = text
                frontView.hidden = false
                backView.hidden = true
            }
        }
    }
    
    // badge颜色 默认为红色
    var badgeColor: UIColor = UIColor.redColor()
    // 是否 爆炸效果
    var isShowBomAnimation: Bool = true
    // 是否 弹簧效果
    var isShowSpringAnimation: Bool = true
    
    var badgeFont: UIFont = UIFont.systemFontOfSize(12)
    // 弹簧效果幅度，值越大，幅度越大，默认为20.0
    var springRange: CGFloat = 20.0
    
    // MARK: - Private Property
    // 默认拉伸长度比率
    private let defaultRatio: CGFloat = 0.2
    private var ratio: CGFloat = 0.0
    // 默认最小半径
    private let defaultLimite: CGFloat = 4
    private var miniRad: CGFloat = 0.0
    
    private var fillColor: UIColor = UIColor.redColor()
    
    private var orgialPoint: CGPoint = CGPointZero
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    private var frontView: UIView = UIView()
    
    private var backView: UIView = UIView()
    
    private var p_overView: UIControl?
//    private var overView: UIControl? {
//        set(value) {
//            p_overView = value
//        }
//        get {
//            if p_overView == nil {
//                p_overView = UIControl(frame: UIScreen.mainScreen().bounds)
//                p_overView!.backgroundColor = UIColor.greenColor()
//                p_overView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            }
//            return p_overView
//        }
//    }
    private var overView: UIControl?
    
    private weak var containerView: UIView?
    
    private var badgeLabel: UILabel = UILabel()
    
    private var r1: CGFloat = 0.0
    private var r2: CGFloat = 0.0
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
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        self.clipsToBounds = true
        orgialPoint = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5)
        ratio = defaultRatio
        miniRad = defaultLimite
        
        backView.hidden = true
        backView.clipsToBounds = true
        backView.frame = CGRectMake(0, 0, frame.size.width,  frame.size.height)
        backView.center = orgialPoint
        backView.layer.cornerRadius = backView.frame.size.height * 0.5
        backView.backgroundColor = UIColor.yellowColor()
        self.addSubview(backView)
        
        frontView.clipsToBounds = true
        frontView.bounds = CGRectMake(0, 0, frame.size.width,  frame.size.height)
        frontView.center = orgialPoint
        frontView.layer.cornerRadius = frontView.frame.size.height * 0.5
        frontView.backgroundColor = UIColor.blueColor()
        self.addSubview(frontView)
        
        badgeLabel.textAlignment = .Center
        badgeLabel.textColor = UIColor.whiteColor()
        badgeLabel.frame = frontView.bounds
        badgeLabel.font = badgeFont
        frontView.addSubview(badgeLabel)
        
        self.bringSubviewToFront(frontView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ZZBadgeLabel.panGestureAction(_:)))
        frontView.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        badgeLabel.center = CGPointMake(frontView.frame.size.width * 0.5, frontView.frame.size.height * 0.5)
        frontView.bounds = bounds
    }
    
    func hiddenBadgeButton(hidden: Bool) -> Void {
        frontView.hidden = hidden
        backView.hidden = false
    }
    
//    var isHidden: Bool {
//        get {
//            return frontView.hidden
//        }
//    }
    
    // MARK: - Action
    // MARK: 拖动手势
    func panGestureAction(sender: UIGestureRecognizer) -> Void {
        let touchPoint = sender.locationInView(self)
        switch sender.state {
        case .Began:
            self.beginDrag()
        case .Changed:
            self.dragMovingWitTouchPoint(touchPoint)
        case .Ended:
            self.dragFinishWithTouchPoint(touchPoint)
        case .Failed:
            self.dragFinishWithTouchPoint(touchPoint)
        case .Cancelled:
            self.dragFinishWithTouchPoint(touchPoint)
        default:
            break
        }
    }
    /**
     开始拖拽
     */
    private func beginDrag() -> Void {
        backView.hidden = false
        fillColor = self.badgeColor
        frontView.layer.removeAllAnimations()
        self.convertToOverView()
    }
    /**
     正在拖拽
     */
    private func dragMovingWitTouchPoint(point: CGPoint) -> Void {
        let touchPoint = containerView!.convertPoint(point, toView: overView)
        if r1 < miniRad {
            fillColor = UIColor.clearColor()
            backView.hidden = true
            shapeLayer.removeFromSuperlayer()
        } else {
            backView.hidden = false
            fillColor = badgeColor
        }
        
//        self.center = touchPoint
        frontView.center = touchPoint
        
        print("frontView : \(frontView)")
        
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
        r2 = frontView.frame.size.height * 0.5
        r1 = r2 - distance * ratio
        pointA = CGPointMake(x1 - r1 * cos, y1 + r1 * sin)
        pointB = CGPointMake(x1 + r1 * cos , y1 - r1 * sin)
        pointC = CGPointMake(x2 + r2 * cos, y2 - r2 * sin)
        pointD = CGPointMake(x2 - r2 * cos, y2 + r2 * sin)
        pointP = CGPointMake(pointB.x + distance * 0.5 * sin, pointB.y + distance * 0.5 * cos)
        pointO = CGPointMake(pointA.x + distance * 0.5 * sin, pointA.y + distance * 0.5 * cos)
        pointG = CGPointMake(x1 + springRange * sin, y1 + springRange * cos)
        
        self.backView.bounds = CGRectMake(0, 0, r1 * 2, r1 * 2)
        self.backView.layer.cornerRadius = r1
        
        self.draw()
    }
    /**
     完成拖拽
     */
    private func dragFinishWithTouchPoint(point: CGPoint) -> Void {
        frontView.center = orgialPoint
        if r1 > miniRad {
            if isShowSpringAnimation {
                self.displaySpringAnimation()
            }
        }
        if r1 < miniRad {
            frontView.hidden = true
            badgeLabel.text = ""
            if isShowBomAnimation {
                self.displayBomAnimationWithPoint(point)
            }
        }
        backView.bounds = CGRectMake(0, 0, frontView.frame.size.width, frontView.frame.size.width)
        backView.layer.cornerRadius = frontView.frame.size.height * 0.5
        shapeLayer.removeFromSuperlayer()
        backView.hidden = true
        self.convertToOrigalContainerView()
    }
    
    // MARK: - Utils
    private func convertToOverView() {
        if overView == nil {
            overView = UIControl(frame: UIScreen.mainScreen().bounds)
            overView!.backgroundColor = UIColor.greenColor()
            overView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            for window in UIApplication.sharedApplication().windows {
                let windowOnMainScreen = (window.screen == UIScreen.mainScreen())
                let windowIsVisible = ((window.hidden == false) && (window.alpha > 0))
                let windowLevelNormal = (window.windowLevel == UIWindowLevelNormal)
                if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
//                    let windowView = UIView(frame: UIScreen.mainScreen().bounds)
//                    windowView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//                    windowView.backgroundColor = UIColor.clearColor()
//                    window.addSubview(windowView)
//                    self.overView = windowView
                    window.addSubview(self.overView!)
                    break
                }
            }
        } else {
            self.overView!.superview?.bringSubviewToFront(self.overView!)
        }
        containerView = self.superview
        center = containerView!.convertPoint(center, toView: overView)
        overView!.addSubview(self)
    }
    
    private func convertToOrigalContainerView() {
        center = overView!.convertPoint(center, toView: containerView)
        containerView!.addSubview(self)
        containerView!.setNeedsDisplay()
        print("\(containerView)")
        overView!.removeFromSuperview()
        overView = nil
    }
    
    private func draw() {
        let path = UIBezierPath()
        path.moveToPoint(pointA)
        path.addQuadCurveToPoint(pointD, controlPoint: pointO)
        path.addLineToPoint(pointC)
        path.addQuadCurveToPoint(pointB, controlPoint: pointP)
        path.moveToPoint(pointA)
        if backView.hidden == false {
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = fillColor.CGColor
            layer.insertSublayer(shapeLayer, below: frontView.layer)
        }
    }
    
    // MARK: - Animation
    // 弹簧动画
    private func displaySpringAnimation() {
        let springAnimation = CASpringAnimation(keyPath: "position")
        springAnimation.stiffness = 1000
        springAnimation.damping = 5
        springAnimation.mass = 0.5
        springAnimation.initialVelocity = 70
        springAnimation.fromValue = NSValue(CGPoint: pointG)
        springAnimation.toValue = NSValue(CGPoint: orgialPoint)
        springAnimation.repeatCount = 1
        frontView.layer.addAnimation(springAnimation, forKey: nil)
    }
    // 爆炸动画
    private func displayBomAnimationWithPoint(point: CGPoint) {
        let bomView = UIImageView(frame: CGRectMake(0, 0, frontView.frame.size.width, frontView.frame.size.width))
        bomView.center = point
        self.addSubview(bomView)
        var bomArry: [UIImage] = []
        for i in 0..<5 {
            let imageName = String(format: "%ld", i)
            let image = UIImage(named: imageName)
            if image != nil {
                bomArry.append(image!)
            }
        }
        bomView.animationImages = bomArry
        bomView.animationDuration = 0.5
        bomView.animationRepeatCount = 1
        bomView.startAnimating()
    }

}

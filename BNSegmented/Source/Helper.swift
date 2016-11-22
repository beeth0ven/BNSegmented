//
//  Helper.swift
//  Test
//
//  Created by luojie on 16/5/18.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        get { return CGPoint(x: midX, y: midY) }
        set {
            origin = CGPoint(
                x: newValue.x - width/2,
                y: newValue.y - height/2
            )
        }
    }
}

let π = CGFloat(M_PI)

extension UIBezierPath {
    convenience init(circleCenter center: CGPoint, radius: CGFloat) {
        self.init(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2*π,
            clockwise: true
        )
    }
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func +=(left: inout CGPoint, right: CGPoint) {
    left = left + right
}

extension UIScrollView {
    
    enum ScrollPosition {
        case top
        case bottom
        case left
        case right
    }
    
    func scrollsTo(_ position: ScrollPosition, animated: Bool = true) {
        var offset: CGPoint!
        defer { setContentOffset(offset, animated: animated) }
        switch position {
        case .top:      offset = CGPoint(x: contentOffset.x, y: 0)
        case .bottom:   offset = CGPoint(x: contentOffset.x, y: bottomOffsetY)
        case .left:     offset = CGPoint(x: 0,               y: contentOffset.y)
        case .right:    offset = CGPoint(x: rightOffsetX,    y: contentOffset.y)
        }
    }
    
    var bottomOffsetY: CGFloat { return max(0, contentSize.height - bounds.height) }
    var rightOffsetX: CGFloat { return max(0, contentSize.width - bounds.width) }
    
    
    func scrollBy(x: CGFloat = 0, y: CGFloat = 0, animated: Bool = true) {
        let offset = contentOffset + CGPoint(x: x, y: y)
        setContentOffset(offset, animated: animated)
    }
    
    var remainHeight: CGFloat {
        return max(0, contentSize.height - (contentOffset.y + bounds.height))
    }
}


extension UIViewController {
    /**
     Return a viewController's parentViewController which is a given Type, Usage:
     ```swift
     return viewController.parentViewControllerWithType(LoginContainerViewController)
     ```
     Above code shows how to get viewController's parent LoginContainerViewController
     */
    func parentViewControllerWithType<VC: UIViewController>(_ type: VC.Type) -> VC? {
        var parentViewController = self.parent
        while parentViewController != nil {
            if let viewController = parentViewController as? VC {
                return viewController
            }
            parentViewController = parentViewController!.parent
        }
        return nil
    }
    
    /**
     Return a viewController's childViewController which is a given Type, Usage:
     ```swift
     return viewController.childViewControllerWithType(QQPlayerViewController)
     ```
     Above code shows how to get viewController's child QQPlayerViewController
     */
    func childViewControllerWithType<ViewController: UIViewController>(_ type: ViewController.Type) -> ViewController? {
        /**
         recursion to get childViewController.
         here is exmple to show the search order number:
         rootViewController:                           0
         childViewControllers:                         1         5         9
         childViewControllers's childViewControllers:  2 3 4     6 7 8     10 11 12
         */
        for childViewController in childViewControllers {
            if let viewController = childViewController as? ViewController {
                return viewController
            }
            
            if let viewController = childViewController.childViewControllerWithType(ViewController.self) {
                return viewController
            }
        }
        return  nil
    }
    
}

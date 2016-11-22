//
//  BNBubbleSegmentedControl.swift
//  BNSegmented
//
//  Created by luojie on 16/5/18.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

open class BNBubbleSegmentedControl: BNSegmentedControl {
    
    @IBInspectable open
    var showBubble: Bool = false {
        didSet { updateBubbleButtons() }
    }
    
    @IBInspectable open
    var bubbleColor: UIColor = UIColor.red {
        didSet { updateBubbleButtons() }
    }
    
    @IBInspectable open
    var bubbleOffset: CGPoint = CGPoint(x: 30, y: -10) {
        didSet { updateBubbleButtons() }
    }
    
    var bubbleButtons: [BNBubbleButton] {
        return segmentItems.map { $0 as! BNBubbleButton }
    }
    
    override func button(_ frame: CGRect) -> UIButton {
        let bubbleButton = BNBubbleButton(type: .custom)
        bubbleButton.frame = frame
        updateBubbleButton(bubbleButton)
        return bubbleButton
    }
    
    fileprivate func updateBubbleButtons() {
        bubbleButtons.forEach(updateBubbleButton)
    }
    
    fileprivate func updateBubbleButton(_ bubbleButton: BNBubbleButton) {
        bubbleButton.showBubble = showBubble
        bubbleButton.bubbleColor = bubbleColor
        bubbleButton.bubbleOffset = bubbleOffset
    }
}

@IBDesignable
open class BNBubbleButton: UIButton {
    
    @IBInspectable open
    var showBubble: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable open
    var bubbleColor: UIColor = UIColor.red {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable open
    var bubbleOffset: CGPoint = CGPoint(x: 30, y: -10){
        didSet { setNeedsDisplay() }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard showBubble else { return }
        let circleCenter = bounds.center + bubbleOffset
        let cicle = UIBezierPath(circleCenter: circleCenter, radius: 3)
        bubbleColor.set()
        cicle.fill()
    }
}


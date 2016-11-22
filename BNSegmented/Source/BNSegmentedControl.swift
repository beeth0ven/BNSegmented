//
//  CustomSegement.swift
//  CustomSegement
//
//  Created by luojie on 15/12/15.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

@IBDesignable

open class BNSegmentedControl: UIControl {
    
    fileprivate struct Constants {
        fileprivate struct SelectedBackgroundView{
            static let DefaultShowed = true
            static let DefaultViewHeight: CGFloat = 4
            static let DefaultWidth: CGFloat = 50
            static let DefaultBackgroundColor = UIColor.darkGray
        }
        
        fileprivate struct Title {
            static let DefaultFontSize: CGFloat = 16
            static let DefalutColor = UIColor.darkGray
            static let DefalutHighlightedColor = UIColor.yellow
            static let DefalutSelectedColor = UIColor.white
        }
        
        fileprivate struct Segment {
            static let DefaultTitle = ""
            static let DefaultSegments: [SegmentTitleProvider] = ["Title1", "Title2"]
        }
        
    }
    
    // Background
    @IBInspectable open
    var sbvShowed: Bool = Constants.SelectedBackgroundView.DefaultShowed { didSet { updateSelectedBackgroundFrame() } }
    
    @IBInspectable open
    var sbvColor: UIColor = Constants.SelectedBackgroundView.DefaultBackgroundColor { didSet { updateSelectedBackgroundColor() } }
    
    @IBInspectable open
    var sbvHeight: CGFloat = Constants.SelectedBackgroundView.DefaultViewHeight { didSet { updateSelectedBackgroundFrame() } }

    @IBInspectable open
    var sbvWidth: CGFloat = Constants.SelectedBackgroundView.DefaultWidth { didSet { updateSelectedBackgroundFrame() } }
    
    // Title
    @IBInspectable open
    var fontSize: CGFloat = Constants.Title.DefaultFontSize { didSet { updateTitleStyle() } }
    
    @IBInspectable open
    var titleColor: UIColor = Constants.Title.DefalutColor { didSet { updateTitleStyle() } }
    
    @IBInspectable open
    var highlightedTC: UIColor = Constants.Title.DefalutHighlightedColor { didSet { updateTitleStyle() } }
    
    @IBInspectable open
    var selectedTC: UIColor = Constants.Title.DefalutSelectedColor { didSet { updateTitleStyle() } }
    
    // Segment
    @IBInspectable open
    var segmentTitle: String = Constants.Segment.DefaultTitle { didSet { updateSegments(segmentTitle) } }
    
    open var segments: [SegmentTitleProvider] = Constants.Segment.DefaultSegments { didSet { updateSegments(nil) } }
    
    open fileprivate(set) var segmentItems: [UIButton] = []
    
    // Selected
    @IBInspectable open
    var selectedIndex: Int = 0 {
        didSet {
            selectedIndex = segments.validIndexFor(selectedIndex)!
            if selectedIndex != oldValue { valueChanged = true }
            if selectedIndex < segmentItems.endIndex {
                updateSelectedIndex(animationEnable)
            }
        }
    }
    
    fileprivate var valueChanged = false
    
    @IBInspectable open
    var animationEnable: Bool = true
    
    open let selectedBackgroundView = UIView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureElements()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureElements()
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateSegmentFrames()
        updateSelectedIndex(false)
    }
    
    open func segmentTouched(_ sender: UIButton) {
        guard let index = segmentItems.index(of: sender) else { return }
        selectedIndex = index
    }
    
    func button(_ frame: CGRect) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        return button
    }
}

// MARK: - Private methods
private extension BNSegmentedControl {
    func configureElements() {
        insertSubview(selectedBackgroundView, at: 0)
        updateSegments(nil)
    }
    
    func updateSegments(_ titles: String?) {
        if let titles = titles {
            let extractedTitles = titles
                .characters
                .split(maxSplits: 100, omittingEmptySubsequences: true, whereSeparator: { $0 == "," })
                .map { String($0) }
            
            segments = extractedTitles.map { $0 }
            return
        }
        
        segmentItems.removeFromSuperview()
        segmentItems.removeAll(keepingCapacity: true)
        
        // Reset data
        if segments.count > 0 {
            let itemWidth: CGFloat = frame.width / CGFloat(segments.count)
            for (index, segment) in segments.enumerated() {
                let item = button(CGRect(
                    x: itemWidth * CGFloat(index),
                    y: 0,
                    width: itemWidth,
                    height: frame.height)
                )
                
                item.isSelected = (index == selectedIndex)
                item.setTitle(segment.segmentTitle, for: UIControlState())
                item.addTarget(self, action: #selector(BNSegmentedControl.segmentTouched(_:)), for: .touchUpInside)
                
                addSubview(item)
                segmentItems.append(item)
            }
        }
        
        updateTitleStyle()
        updateSelectedIndex(false)
    }
    
    func updateSegmentFrames() {
        guard segments.count > 0 else { return }
        let itemWidth: CGFloat = frame.width / CGFloat(segments.count)
        for (index, item) in segmentItems.enumerated() {
            item.frame = CGRect(
                x: itemWidth * CGFloat(index),
                y: 0,
                width: itemWidth,
                height: frame.height
            )
        }
    }
    
    func updateTitleStyle() {
        segmentItems.forEach {
            item in
            item.setTitleColor(titleColor, for: UIControlState())
            item.setTitleColor(highlightedTC, for: .highlighted)
            item.setTitleColor(selectedTC, for: .selected)
            item.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    func updateSelectedIndex(_ animated: Bool) {
        segmentItems.forEach { $0.isSelected = false }
        if valueChanged {
            valueChanged = false
            sendActions(for: .valueChanged)
        }
        if animated {
            UIView.animate(withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.3,
                options: .curveEaseOut,
                animations: {
                    self.updateSelectedBackgroundFrame()
                },
                completion: {
                    _ in
                    self.segmentItems[self.selectedIndex].isSelected = true
                }
            )
        } else {
            updateSelectedBackgroundFrame()
            segmentItems[selectedIndex].isSelected = true
        }
        
    }
    
    func updateSelectedBackgroundColor() {
        selectedBackgroundView.backgroundColor = sbvColor
    }
    
    func updateSelectedBackgroundFrame() {
        guard sbvShowed else {
            selectedBackgroundView.frame = CGRect.zero
            return
        }
        
        guard selectedIndex < segmentItems.count else { return }
        let segment = segmentItems[selectedIndex]
        let frame = segment.frame

        let topInset = sbvHeight == 0 ? 0 : frame.size.height - sbvHeight
        let widthInset = sbvWidth == 0 ? 0 : (frame.size.width - sbvWidth) / 2
//        frame.origin.y = sbvHeight > 0 ? self.frame.height - sbvHeight : 0
//        let sbWidthInset = (frame.size.width - sbWidth) / 2
        selectedBackgroundView.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(topInset, widthInset, 0, widthInset))
    }
}

// MARK: - DAta types, Protocol & Extensions
public protocol SegmentTitleProvider {
    var segmentTitle: String { get }
}

extension String: SegmentTitleProvider {
    public var segmentTitle: String {
        return self
    }
}

extension UIViewController: SegmentTitleProvider {
    public var segmentTitle: String {
        return title ?? ""
    }
}

public func fix<T : Comparable>(_ x: T,betweenMin minValue: T, max maxValue: T) -> T {
    assert(minValue <= maxValue)
    return max(minValue, min(x, maxValue))
}

extension Array {
    public func validIndexFor(_ index: Index) -> Index? {
        guard count > 0 else { return nil }
        return fix(index, betweenMin: startIndex, max: count - 1)
    }
}

extension Array where Element: UIView {
    func removeFromSuperview() {
        forEach { $0.removeFromSuperview() }
    }
}





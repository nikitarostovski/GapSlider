//
//  RangeSlider.swift
//  TelegramCharts
//
//  Created by Rost on 11/03/2019.
//  Copyright © 2019 Rost. All rights reserved.
//

import UIKit

@IBDesignable
public class GapSlider: UIControl {

    // MARK: - Public properties

    public var delegate: GapSliderDelegate?

    @IBInspectable
    public var lowerValue: CGFloat = 0 {
        didSet {
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)

            updateLeftThumbPosition()
            updateCenterThumbPosition()

            CATransaction.commit()
        }
    }
    @IBInspectable
    public var upperValue: CGFloat = 1 {
        didSet {
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)

            updateRightThumbPosition()
            updateCenterThumbPosition()

            CATransaction.commit()
        }
    }
    @IBInspectable
    public var minimumValue: CGFloat = 0 {
        didSet {
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)

            updateLayout()

            CATransaction.commit()
        }
    }
    @IBInspectable
    public var maximumValue: CGFloat = 1 {
        didSet {
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)

            updateLayout()

            CATransaction.commit()
        }
    }

    public var style: GapSliderStyle = GapSliderStyle.defaultStyle() {
        didSet {
            updateStyle()
        }
    }

    // MARK: - Private properties

    private var leftThumb: LeftThumb!
    private var rightThumb: RightThumb!
    private var centerThumb: CenterThumb!

    private var tintLayer = CAShapeLayer()
    private var unselectedTintColor: UIColor = UIColor.black.withAlphaComponent(0.5)

    private var previousLocationX: CGFloat = 0
    private var touchResult = ThumbHitTestResult.none

    //MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
        updateStyle()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)

        leftThumb.frame = CGRect(origin: leftThumb.frame.origin, size: CGSize(width: 44, height: layer.bounds.height))
        rightThumb.frame = CGRect(origin: rightThumb.frame.origin, size: CGSize(width: 44, height: layer.bounds.height))
        centerThumb.frame = CGRect(origin: centerThumb.frame.origin, size: CGSize(width: centerThumb.frame.width, height: layer.bounds.height))
        tintLayer.frame = layer.bounds
        updateLayout()

        CATransaction.commit()
    }

    // MARK: - Setup

    private func initialSetup() {
        isExclusiveTouch = true

        tintLayer.masksToBounds = true
        layer.addSublayer(tintLayer)

        leftThumb = LeftThumb()
        layer.addSublayer(leftThumb)

        rightThumb = RightThumb()
        layer.addSublayer(rightThumb)

        centerThumb = CenterThumb()
        layer.addSublayer(centerThumb)
    }

    // MARK: - Style

    private func updateStyle() {
        backgroundColor = style.backgroundColor

        leftThumb.applyStyle(style: style)
        rightThumb.applyStyle(style: style)
        centerThumb.applyStyle(style: style)
    }

    // MARK: - Layout
    
    private func updateLayout() {
        updateLeftThumbPosition()
        updateRightThumbPosition()
        updateCenterThumbPosition()
        updateTint()
    }

    private func updateTint() {
        let hollowRect = CGRect(x: leftThumb.frame.minX,
                                y: 0,
                                width: rightThumb.frame.maxX - leftThumb.frame.minX,
                                height: bounds.height)

        let path = UIBezierPath(rect: bounds)
        let hollowPath = UIBezierPath(rect: hollowRect)
        path.append(hollowPath)
        path.usesEvenOddFillRule = true

        tintLayer.fillColor = unselectedTintColor.cgColor
        tintLayer.fillRule = .evenOdd
        tintLayer.path = path.cgPath
    }

    private func updateLeftThumbPosition() {
        leftThumb.position.x = CGFloat(lowerValue) * layer.bounds.width + leftThumb.frame.width / 2
    }

    private func updateRightThumbPosition() {
        rightThumb.position.x = CGFloat(upperValue) * layer.bounds.width - rightThumb.frame.width / 2
    }

    private func updateCenterThumbPosition() {
        centerThumb.frame = CGRect(x: leftThumb.frame.maxX, y: 0, width: rightThumb.frame.minX - leftThumb.frame.maxX, height: layer.bounds.height)
    }
}

// MARK: - Touches

extension GapSlider {

    var minValueDelta: CGFloat {
        return (leftThumb.frame.width + rightThumb.frame.width) / bounds.width
    }

    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let x = touch.location(in: self).x
        previousLocationX = x

        if leftThumb.hitTest(touch.location(in: self)) != .none {
            touchResult = .left
        } else if rightThumb.hitTest(touch.location(in: self)) != .none {
            touchResult = .right
        } else if centerThumb.hitTest(touch.location(in: self)) != .none {
            touchResult = .center
        }
        return touchResult != .none
    }

    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let locationX = touch.location(in: self).x
        let deltaLocation = locationX - previousLocationX
        let deltaValue = CGFloat(maximumValue - minimumValue) * deltaLocation / (bounds.width)
        previousLocationX = locationX

        switch touchResult {
        case .none:
            break
        case .left:
            lowerValue = min(max(minimumValue, lowerValue + deltaValue), upperValue - minValueDelta)
            delegate?.sliderLeftDidChange(sender: self)
        case .right:
            upperValue = max(min(maximumValue, upperValue + deltaValue), lowerValue + minValueDelta)
            delegate?.sliderRightDidChange(sender: self)
        case .center:
            var newDelta: CGFloat = deltaValue
            if lowerValue + deltaValue < minimumValue {
                newDelta = minimumValue - lowerValue
            } else if upperValue + deltaValue > maximumValue {
                newDelta = maximumValue - upperValue
            }
            self.lowerValue += newDelta
            self.upperValue += newDelta
            delegate?.sliderDidScroll(sender: self)
        }
        
        return true
    }

    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        touchResult = .none
    }
}

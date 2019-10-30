//
//  GapSliderStyle.swift
//  GapSlider
//
//  Created by Nikita Rostovskii on 30/10/2019.
//

import UIKit

public struct GapSliderStyle {

    public enum ThumbStyle {
        case line
        case arrow
        case none
    }

    var thumbStyle: ThumbStyle
    var cornerRaius: CGFloat
    var tintColor: UIColor
    var foregroundColor: UIColor
    var backgroundColor: UIColor

    public static func defaultStyle() -> GapSliderStyle {
        return GapSliderStyle(thumbStyle: .arrow,
                              cornerRaius: 2.0,
                              tintColor: UIColor.black.withAlphaComponent(0.5),
                              foregroundColor: UIColor.init(white: 0.9, alpha: 0.8),
                              backgroundColor: UIColor.clear)
    }

    public init(thumbStyle: ThumbStyle, cornerRaius: CGFloat, tintColor: UIColor, foregroundColor: UIColor, backgroundColor: UIColor) {
        self.thumbStyle = thumbStyle
        self.cornerRaius = cornerRaius
        self.tintColor = tintColor
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
}

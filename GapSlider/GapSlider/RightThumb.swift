//
//  RightThumb.swift
//  GapSlider
//
//  Created by Nikita Rostovskii on 30/10/2019.
//

import UIKit

class RightThumb: CALayer {

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyStyle(style: GapSliderStyle) {
        backgroundColor = style.foregroundColor.cgColor
    }
}

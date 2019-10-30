//
//  GapSliderDelegate.swift
//  GapSlider
//
//  Created by Nikita Rostovskii on 30/10/2019.
//

import Foundation

public protocol GapSliderDelegate {
    func sliderLeftDidChange(sender: GapSlider)
    func sliderRightDidChange(sender: GapSlider)
    func sliderDidScroll(sender: GapSlider)
}

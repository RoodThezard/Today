//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/14/22.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(for style: MeetingListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func colors(for style: MeetingListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}

//
//  DebugMaskView.swift
//  SwiftHelper
//
//  Copyright © 2023 mykim. All rights reserved.
//

import UIKit

public class DebugMaskingView: UIView {
    public static let DebugMaskViewTag = 909012313

    var lineColor: UIColor = .red
    var isUseStroke: Bool = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public convenience init(bgColor: UIColor, strokeColor: UIColor = .red, isUseStroke: Bool = false) {
        self.init(frame: .zero)
        self.lineColor = strokeColor
        self.isUseStroke = isUseStroke
        self.backgroundColor = bgColor
    }

    private func setup() {
        self.tag = Self.DebugMaskViewTag
        self.isUserInteractionEnabled = false
    }

    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), isUseStroke else { return }
        let lineWidth: CGFloat = 1.0
        context.setLineWidth(lineWidth)
        context.setStrokeColor(self.lineColor.cgColor)
        context.addRect(self.bounds)
        do {
            let startingPoint = CGPoint.zero
            let endingPoint = CGPoint(x: rect.size.width, y: rect.size.height)
            context.move(to: startingPoint )
            context.addLine(to: endingPoint )
        }
        do {
            let startingPoint = CGPoint(x: rect.size.width, y: 0)
            let endingPoint = CGPoint(x: 0, y: rect.size.height)
            context.move(to: startingPoint )
            context.addLine(to: endingPoint )
        }
        context.strokePath()
    }
}

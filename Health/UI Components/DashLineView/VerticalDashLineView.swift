//
//  VerticalDashLineView.swift
//  Health
//
//  Created by Weichen Jiang on 8/13/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class VerticalDashLineView: UIView {
    
    // MARK: Properties
    
    private let length: CGFloat
    private let spacing: CGFloat
    private let color: UIColor
    
    // MARK: Initialization
    
    init(frame: CGRect, length: CGFloat, spacing: CGFloat, color: UIColor) {
        self.length = length
        self.spacing = spacing
        self.color = color
        
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.beginPath()
        context.setLineWidth(rect.width)
        context.setStrokeColor(color.cgColor)
        context.setLineDash(phase: 0.0, lengths: [length, spacing])
        context.move(to: CGPoint(x: 0.0, y: 0.0))
        context.addLine(to: CGPoint(x: 0.0, y: rect.height))
        context.strokePath()
//        context.closePath()
    }
    
    
    
}

//
//  CGPointExtension.swift
//  PipeSlider
//
//  Created by mehdi on 10/30/1398 AP.
//  Copyright © 1398 AP nikoosoft. All rights reserved.
//

import UIKit

extension CGPoint {
    func adding(xValue: CGFloat) -> CGPoint { return CGPoint(x: self.x + xValue, y: self.y) }
    func adding(yValue: CGFloat) -> CGPoint { return CGPoint(x: self.x, y: self.y + yValue) }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    static prefix func - (lhs: CGPoint) -> CGPoint {
        return CGPoint(x: -lhs.x, y: -lhs.y)
    }
    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }

    static func == (left: CGPoint, right: CGPoint) -> Bool {
        return (left.x == right.x && left.y == right.y)
    }

}

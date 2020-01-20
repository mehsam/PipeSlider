//
//  DirectionalRect.swift
//  PipeSlider
//
//  Created by mehdi on 10/30/1398 AP.
//  Copyright © 1398 AP nikoosoft. All rights reserved.
//

import UIKit
protocol DirectionalRect {
    var inset: CGFloat { get set }
    var bound: CGSize { get set }
    var value: CGFloat { get set }
    mutating func setValue(form point: CGPoint)
    func point() -> CGPoint
    func origion() -> CGPoint
    func size() -> CGSize
    func frame() -> CGRect
}
extension DirectionalRect {
    func frame() -> CGRect {
        return CGRect(origin: origion(), size: size())
    }
}
struct LeftToRightRect: DirectionalRect {
    var inset: CGFloat
    var bound: CGSize
    var value: CGFloat
    func origion() -> CGPoint {
        return CGPoint(x: inset, y: inset)
    }
    func size() -> CGSize {
        return CGSize(width: value * (bound.width - 2.0 * inset), height: bound.height - 2.0 * inset)
    }
    mutating func setValue(form point: CGPoint) {
        let width = bound.width - 2.0 * inset
        let len = min(max((point.x - inset), 0.0), width)
        value = width > 0.0 ? (len / width) : 0.0
    }
    func point() ->CGPoint {
        return CGPoint(x: inset + size().width, y: 0)
    }
}
struct TopDownRect: DirectionalRect {
    var inset: CGFloat
    var bound: CGSize
    var value: CGFloat
    func origion() -> CGPoint {
        return CGPoint(x: inset, y: inset)
    }
    func size() -> CGSize {
        return CGSize(width: bound.width - 2.0 * inset , height: value * (bound.height - 2.0 * inset))
    }
    mutating func setValue(form point: CGPoint) {
        let height = bound.height - 2.0 * inset
        let len = min(max((point.y - inset), 0.0), height)
        value = height > 0.0 ? (len / height) : 0.0
    }
    func point() ->CGPoint {
        return CGPoint(x: 0, y: inset + size().height)
    }


}
struct BottomUpRect: DirectionalRect {
    var inset: CGFloat
    var bound: CGSize
    var value: CGFloat
    func origion() -> CGPoint {
        return CGPoint(x: inset, y:  bound.height - size().height - inset)
    }
    func size() -> CGSize {
        return CGSize(width: bound.width - 2.0 * inset, height: value * (bound.height - 2.0 * inset))
    }
    mutating func setValue(form point: CGPoint) {
        let height = bound.height - 2.0 * inset
        let len = min(max((height - point.y + inset), 0.0), height)
        value = height > 0.0 ? (len / height) : 0.0
    }
    func point() ->CGPoint {
        return CGPoint(x: 0, y: bound.height - size().height - inset)
    }

}
struct RightToLeftRect: DirectionalRect {
    var inset: CGFloat
    var bound: CGSize
    var value: CGFloat
    func origion() -> CGPoint {
        return CGPoint(x: bound.width - size().width - inset, y: inset)
    }
    func size() -> CGSize {
        return CGSize(width: value * (bound.width - 2.0 * inset), height: bound.height - 2.0 * inset)
    }
    mutating func setValue(form point: CGPoint) {
        let width = bound.width - 2.0 * inset
        let len = min(max((width - point.x + inset), 0.0), width)
        value = width > 0.0 ? (len / width) : 0.0
    }
    func point() ->CGPoint {
        return CGPoint(x: bound.width - inset - size().width, y: 0)
    }

}

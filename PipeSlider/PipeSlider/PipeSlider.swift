//
//  AdjustableColumnView.swift
//  PipeSlider
//
//  Created by mehdi on 10/29/1398 AP.
//  Copyright © 1398 AP nikoosoft. All rights reserved.
//

import UIKit

public enum GrowingDirection: Int {
    case bottomUp = 0
    case topDown = 1
    case leftToRight = 2
    case rightToLeft = 3
}
public protocol PipeSliderDelegate {
    func pipeView(_ sender: PipeSlider, didChanged value: Double)
}

@IBDesignable
open class PipeSlider: UIView {

    public var delegate: PipeSliderDelegate?
    
    @IBInspectable
    public var pipeColor: UIColor = .blue {
        didSet {
            pistonLayer.backgroundColor = pipeColor.cgColor
        }
    }
    @IBInspectable
    public var textColor: UIColor = .white {
        didSet {
            textLabel.textColor = textColor
        }
    }
    @IBInspectable
    public var inset: CGFloat = 4.0 {
        didSet {
            frameGenerator!.inset = inset
            pistonLayer.frame = frameGenerator!.frame()
        }
    }
    
    var direction: GrowingDirection = .bottomUp {
        didSet {
            frameGenerator = getFrameGenerator(direction)
        }
    }
    public func setValue(_ value: Double) {
        updatePipe(with: value)
        self.value = value
    }
    public private(set) var value: Double = 50.0 {
        didSet {
            textLabel.text = String(format: "%02.1f", value)
            delegate?.pipeView(self, didChanged: value)
        }
    }
    @IBInspectable
    public var maximum: Double = 100.0
    @IBInspectable
    public var minimum: Double = -100.0
    
    private var frameGenerator: DirectionalRect!
    private var pistonLayer: CALayer = CALayer()
    private var textLabel: UILabel = UILabel()
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        frameGenerator.setValue(form: location)
        pistonLayer.frame = frameGenerator.frame()
        value = calulateValue()
    }

    @objc func onPan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translation = sender.translation(in: self)
            let location = frameGenerator.point() + translation
            sender.setTranslation(.zero, in: self)
            frameGenerator.setValue(form: location)
            pistonLayer.frame = frameGenerator.frame()
            value = calulateValue()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        frameGenerator.bound = self.bounds.size
        pistonLayer.frame = frameGenerator.frame()
        setCornerRadius(for: pistonLayer)
        setCornerRadius(for: self.layer)
        textLabel.frame = centerRect(of: textLabel.font.lineHeight)
    }
    private func configurePistonLayer() {
        pistonLayer.frame = frameGenerator.frame()
        pistonLayer.backgroundColor = pipeColor.cgColor
        self.layer.addSublayer(pistonLayer)
    }
    
    private func configureTextLayer() {
        let font = UIFont.systemFont(ofSize: min(bounds.width, bounds.height, 48.0) / 4.0, weight: .bold)
        textLabel.frame = centerRect(of: font.lineHeight)
        textLabel.text = String(format: "%02.1f", value)
        textLabel.textColor = textColor
        textLabel.font = font
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        self.addSubview(textLabel)
    }

    private func setup() {
        frameGenerator = getFrameGenerator(direction)
        configurePistonLayer()
        configureTextLayer()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self,
        action: #selector(onPan)))
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    fileprivate func getFrameGenerator(_ direction: GrowingDirection) -> DirectionalRect {
        switch direction {
        case .bottomUp :
            return BottomUpRect(inset: inset,
                                          bound: bounds.size,
                                          value: CGFloat(value01(value)))
        case .leftToRight:
            return LeftToRightRect(inset: inset,
                                             bound: bounds.size,
                                             value: CGFloat(value01(value)))
            
        case .rightToLeft:
            return RightToLeftRect(inset: inset,
                                             bound: bounds.size,
                                             value: CGFloat(value01(value)))
            
        case .topDown:
            return TopDownRect(inset: inset,
                                         bound: bounds.size,
                                         value: CGFloat(value01(value)))
            
        }
    }
    private func setCornerRadius( for layer: CALayer) {
        switch direction {
            case .bottomUp, .topDown :
                layer.cornerRadius = layer.bounds.width <= 40.0 ? layer.bounds.width / 2.0 : layer.bounds.width / 10.0
            default:
                layer.cornerRadius = layer.bounds.height <= 40.0 ? layer.bounds.height / 2.0 : layer.bounds.height / 10.0
        }
        layer.masksToBounds = true

    }
    private func centerRect(of height: CGFloat) -> CGRect {
        return CGRect(x:0 , y: (bounds.height - height) / 2.0, width: bounds.width, height: height)
    }
    
    private func value01(_ value: Double) -> Double {
        let maxLen = (maximum - minimum)
        let len = value - minimum
        if len >= 0 && maxLen > 0 {
            return (len / maxLen)
        }
        return 0
    }
    private func updatePipe( with value: Double) {
        frameGenerator.value = CGFloat(value01(value))
        pistonLayer.frame = frameGenerator.frame()
    }
    private func calulateValue() -> Double {
        return minimum + Double(frameGenerator.value) * (maximum - minimum)
    }
}


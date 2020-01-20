//
//  AdjustableColumnView.swift
//  PipeSlider
//
//  Created by mehdi on 10/29/1398 AP.
//  Copyright © 1398 AP nikoosoft. All rights reserved.
//

import UIKit

enum GrowingDirection: Int {
    case bottomUp = 0
    case topDown = 1
    case leftToRight = 2
    case rightToLeft = 3
}
protocol PipeSliderDelegate {
    func pipeView(_ sender: PipeSlider, didChanged value: Double)
}
class PipeSlider: UIView {

    var delegate: PipeSliderDelegate?
    var pipeColor: UIColor = .blue {
        didSet {
            pistonLayer.backgroundColor = pipeColor.cgColor
        }
    }
    var textColor: UIColor = .white {
        didSet {
            textLabel.textColor = textColor
        }
    }
    var inset: CGFloat = 4.0 {
        didSet {
            frameGenerator.inset = inset
            pistonLayer.frame = frameGenerator.frame()
        }
    }
    var direction: GrowingDirection? {
        didSet {
            switch direction! {
            case .bottomUp:
                frameGenerator = BottomUpRect(inset: inset,
                                                  bound: bounds.size,
                                                  value: CGFloat(value01(value)))
            case .leftToRight:
                frameGenerator = LeftToRightRect(inset: inset,
                                                  bound: bounds.size,
                                                  value: CGFloat(value01(value)))

            case .rightToLeft:
                frameGenerator = RightToLeftRect(inset: inset,
                                                  bound: bounds.size,
                                                  value: CGFloat(value01(value)))

            case .topDown:
                frameGenerator = TopDownRect(inset: inset,
                                                  bound: bounds.size,
                                                  value: CGFloat(value01(value)))

            }
        }
    }
    private var frameGenerator: DirectionalRect!
    func setValue(_ value: Double) {
        updatePipe(with: value)
        self.value = value
    }
    private(set) var value: Double = 0.0 {
        didSet {
            textLabel.text = String(format: "%02.1f", value)
            delegate?.pipeView(self, didChanged: value)
        }
    }
    var maximum: Double = 100.0
    var minimum: Double = -100.0
    
    private var pistonLayer: CALayer = CALayer()
    private var textLabel = UILabel()
    func centerRect(of height: CGFloat) -> CGRect {
        return CGRect(x:0 , y: (bounds.height - height) / 2.0, width: bounds.width, height: height)
    }

    fileprivate func configurePistonLayer() {
        pistonLayer.frame = frameGenerator.frame()
        pistonLayer.backgroundColor = pipeColor.cgColor
        self.layer.addSublayer(pistonLayer)
    }
    
    fileprivate func configureTextLayer() {
        textLabel.text = "00.0"
        textLabel.textColor = textColor
        textLabel.font = UIFont.systemFont(ofSize: min(bounds.width, bounds.height, 48.0) / 4.0, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.frame = centerRect(of: textLabel.font.lineHeight)
        self.addSubview(textLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if direction == nil {
            direction = .bottomUp
        }
        configurePistonLayer()
        configureTextLayer()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                               action: #selector(onPan)))
    }
    func value01(_ value: Double) -> Double {
        let maxLen = (maximum - minimum)
        let len = value - minimum
        if len >= 0 && maxLen > 0 {
            return (len / maxLen)
        }
        return 0
    }
    func updatePipe( with value: Double) {
        frameGenerator.value = CGFloat(value01(value))
        pistonLayer.frame = frameGenerator.frame()
    }
    func calulateValue() -> Double {
        return minimum + Double(frameGenerator.value) * (maximum - minimum)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    func setCornerRadius( for layer: CALayer) {
        switch direction {
            case .bottomUp, .topDown :
                layer.cornerRadius = layer.bounds.width <= 40.0 ? layer.bounds.width / 2.0 : layer.bounds.width / 10.0
            default:
                layer.cornerRadius = layer.bounds.height <= 40.0 ? layer.bounds.height / 2.0 : layer.bounds.height / 10.0
        }
        layer.masksToBounds = true

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        frameGenerator.bound = self.bounds.size
        pistonLayer.frame = frameGenerator.frame()
        setCornerRadius(for: pistonLayer)
        setCornerRadius(for: self.layer)
        textLabel.frame = centerRect(of: textLabel.font.lineHeight)
    }
}


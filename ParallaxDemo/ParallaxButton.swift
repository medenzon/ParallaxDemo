//
//  ParallaxButton.swift
//  ParallaxDemo
///Users/michaeledenzon/Documents/XcodeProjects/ParallaxDemo/ParallaxDemo/Extensions.swift
//  Created by Michael Edenzon on 3/12/18.
//  Copyright © 2018 Michael Edenzon. All rights reserved.
//

import UIKit

class ParallaxButton: HapticButton {
    
    var containerView: UIView!
    var radius: CGFloat!
    
    var activeViews: [UIView] = []
    
    let multiplier: CGFloat = 15
    let scaleUp = CATransform3DMakeScale(1.0, 1.0, 1.0)
    let scaleDown = CATransform3DMakeScale(1.0, 1.0, 1.0)
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.radius = frame.width / 30
        containerView = UIView(frame: bounds)
        self.layer.masksToBounds = true
        addSubview(containerView)
    }
    
    convenience init(frame: CGRect, layers views: [UIView]) {
        self.init(frame: frame)
        for view in views {
            let width = bounds.width * 1.25
            let height = bounds.height * 1.25
            let x = 0 - ((width - frame.width) / 2)
            let y = 0 - ((height - frame.height) / 2)
            view.frame = CGRect(x: x, y: y, width: width, height: height)
            view.layer.cornerRadius = self.radius
            containerView.addSubview(view)
            activeViews.append(view)
        }
        activeViews.removeLast()
        setupLayer()
    }
    
    private func setupLayer() {
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = radius
    }
    
    private func parallaxSubviews(with offset: Offset) {
        for i in 0..<activeViews.count {
            let xp = offset.x * (CGFloat(i) * multiplier)
            let yp = offset.y * (CGFloat(i) * multiplier)
            activeViews[i].layer.transform = CATransform3DMakeTranslation(xp, yp, 0)
        }
    }
    
    private func offset(_ point: CGPoint) -> Offset {
        let width = superview!.bounds.width
        let height = superview!.bounds.height
        return Offset(x: (0.5 - point.x / width) * -1, y: (0.5 - point.y / height) * -1)
    }
    
    private func transform(_ offset: Offset) -> CATransform3D {
        var transform = scaleUp
        transform.m34 = 1.0/(-500)
        let angle = Angle(x: (offset.x * 15) * (.pi/180), y: (offset.y * 15) * (.pi/180))
        transform = CATransform3DRotate(transform, angle.x, 0, (0.5 - offset.y) * -1, 0)
        return CATransform3DRotate(transform, angle.y, (0.5 - offset.y) * 2, 0, 0)
    }
    
    private func parallax(touches: [UITouch]) {
        for touch in touches {
            let offset = self.offset(touch.preciseLocation(in: superview))
            layer.transform = transform(offset)
            parallaxSubviews(with: offset)
        }
    }
    
    private func removeParallax() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.transform = CATransform3DIdentity
            for view in self.activeViews {
                view.layer.transform = CATransform3DIdentity
            }
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        parallax(touches: (event?.coalescedTouches(for: touch))!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeParallax()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeParallax()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Offset {
    var x: CGFloat
    var y: CGFloat
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

struct Angle {
    var x: CGFloat
    var y: CGFloat
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}


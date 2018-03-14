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
    
    let multiplier: CGFloat = 10
    let scaleUp = CATransform3DMakeScale(1.0, 1.0, 1.0)
    let scaleDown = CATransform3DMakeScale(1.0, 1.0, 1.0)
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.radius = frame.width / 30
        containerView = UIView(frame: bounds)
        addSubview(containerView)
    }
    
    convenience init(frame: CGRect, layers views: [UIView]) {
        self.init(frame: frame)
        for view in views {
            view.frame = bounds
            view.clipsToBounds = true
            view.layer.cornerRadius = self.radius
            containerView.addSubview(view)
            activeViews.append(view)
        }
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
    
    private func parallaxOffset(from touch: UITouch?) -> Offset {
        let touchPoint = touch!.preciseLocation(in: superview)
        let width = superview!.bounds.width
        let height = superview!.bounds.height
        return Offset(x: (0.5 - touchPoint.x / width) * -1, y: (0.5 - touchPoint.y / height) * -1)
    }
    
    private func parallaxTransform(with offset: Offset) -> CATransform3D {
        var transform = scaleUp
        transform.m34 = 1.0/(-500)
        let angle = Angle(x: (offset.x * 15) * (.pi/180), y: (offset.y * 15) * (.pi/180))
        transform = CATransform3DRotate(transform, angle.x, 0, (0.5 - offset.y) * -1, 0)
        return CATransform3DRotate(transform, angle.y, (0.5 - offset.y) * 2, 0, 0)
    }
    
    private func parallax(with touch: UITouch?) {
        let offset = parallaxOffset(from: touch)
        layer.transform = parallaxTransform(with: offset)
        parallaxSubviews(with: Offset(x: offset.x, y: offset.y))
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
        parallax(with: touches.first)
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


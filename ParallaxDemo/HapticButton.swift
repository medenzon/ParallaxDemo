//
//  HapticButton.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/11/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case up, down
}

class HapticButton: UIView {
    
    var lightGenerator: UIImpactFeedbackGenerator?
    var heavyGenerator: UIImpactFeedbackGenerator?
    
    var clicked = false
    var maxForce: CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func press(button direction: Direction) {
        switch direction {
        case .up:
            lightGenerator?.impactOccurred()
            clicked = false
        case .down:
            heavyGenerator?.impactOccurred()
            clicked = true
        }
    }
    
    func prepareGenerators() {
        lightGenerator = UIImpactFeedbackGenerator(style: .medium)
        heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        lightGenerator?.prepare()
        heavyGenerator?.prepare()
    }
    
    func disposeGenerators() {
        lightGenerator = nil
        heavyGenerator = nil
    }
    
    func impact(_ direction: Direction) {
        switch direction {
        case .up:
            lightGenerator?.impactOccurred()
        case .down:
            heavyGenerator?.impactOccurred()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ViewController.swift
//  ParallaxDemo
//
//  Created by Michael Edenzon on 3/13/18.
//  Copyright © 2018 Michael Edenzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var parallaxButtonLayers: [UIView] {
        get {
            return [UIImageView(image: UIImage(named: "layer1.png")),
                    UIImageView(image: UIImage(named: "layer2.png")),
                    UIImageView(image: UIImage(named: "layer3.png"))]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addParallaxButton()
    }
    
    func addParallaxButton() {
        
        let width: CGFloat = 250
        let height: CGFloat = 125
        
        let x = view.center.x - (width / 2)
        let y = view.center.y - (height / 2)
        
        let frame =  CGRect(x: x, y: y, width: width, height: height)
        
        let pv1 = ParallaxButton(frame: frame, layers: parallaxButtonLayers)
        
        view.addSubview(pv1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


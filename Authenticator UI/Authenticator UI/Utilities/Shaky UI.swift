//
//  Shaky UI.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa



internal extension Shakable {
    
    func shake() {
         // From https://stackoverflow.com/a/31755773/3939277
        
        let numberOfShakes: Int = 8
        let durationOfShake: Float = 0.5
        let vigourOfShake: CGFloat = 0.05
        
        let shakeAnimation = CAKeyframeAnimation()
        
        let shakePath = CGMutablePath()
        shakePath.move(to: CGPoint(x: frame.minX, y: frame.minY))
        
        for _ in 1...numberOfShakes {
            shakePath.addLine(to: CGPoint(x: frame.minX - frame.size.width * vigourOfShake,
                                          y: frame.minY))
            shakePath.addLine(to: CGPoint(x: frame.minX + frame.size.width * vigourOfShake,
                                          y: frame.minY))
        }
        
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = CFTimeInterval(durationOfShake)
        self.animations = ["frameOrigin" : shakeAnimation]
        self.animator().setFrameOrigin(frame.origin)
    }
}



internal protocol Shakable: NSAnimatablePropertyContainer {
    var frame: CGRect { get }
    func setFrameOrigin(_ newOrigin: CGPoint)
}



extension NSWindow: Shakable {}
extension NSView: Shakable {}

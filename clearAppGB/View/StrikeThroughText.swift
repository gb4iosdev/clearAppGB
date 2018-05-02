//
//  StrikeThroughText.swift
//  clearAppGB
//
//  Created by Gavin Butler on 2018-04-30.
//  Copyright © 2018 Gavin Butler. All rights reserved.
//

import UIKit
import QuartzCore

class StrikeThroughText: UILabel {

    let strikeThroughLayer: CALayer
    let strikeOutThickness: CGFloat = 2.0
    
    var strikeThrough: Bool {
        didSet {
            strikeThroughLayer.isHidden = !strikeThrough
            if strikeThrough {
                resizeStrikeThrough()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.white.cgColor
        strikeThroughLayer.isHidden = true
        strikeThrough = false
        
        super.init(frame: frame)
        layer.addSublayer(strikeThroughLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }

    func resizeStrikeThrough() {
        
        let textSize = text!.size(withAttributes: [NSAttributedStringKey.font: font])
        
        strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2, width: textSize.width, height: strikeOutThickness)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

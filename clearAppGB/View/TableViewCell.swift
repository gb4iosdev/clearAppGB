//
//  TableViewCell.swift
//  clearAppGB
//
//  Created by Gavin Butler on 2018-04-30.
//  Copyright © 2018 Gavin Butler. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()
    
    var originalCentre = CGPoint()
    var deleteOnDragRelease = false

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        ///Set gradient layer for cell
        
        gradientLayer.frame = bounds
        
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor
        let color3 = UIColor.clear.cgColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.2,0.8, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    ///MARK: - horizontal pan gesture methods
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        /// 1:  Record centre location of the cell:
        if recognizer.state == .began {
            originalCentre = center
        }
        /// 2:  If the offset is greater than half the width of the cell, you consider this to be a delete operation.
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCentre.x + translation.x, y: originalCentre.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3:  Check the flag to see if the action was a delete or not
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        ///This method allows you to cancel the recognition of a gesture before it has begun. Determine whether the pan that is about to be initiated is horizontal or vertical:
        
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {return false}
    
        let translation = panGestureRecognizer.translation(in: superview!)
        
        guard fabs(translation.x) > fabs(translation.y) else {return false}
        
        return true
        
    }
}

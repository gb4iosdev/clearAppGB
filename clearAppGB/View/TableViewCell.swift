//
//  TableViewCell.swift
//  clearAppGB
//
//  Created by Gavin Butler on 2018-04-30.
//  Copyright © 2018 Gavin Butler. All rights reserved.
//

import UIKit

/// A protocol that the TableViewCell uses to inform its delegate of state change
protocol TableViewCellDelegate {
    func toDoItemDeleted(todoItem: ToDoItem, index: IndexPath)    ///indicates that the given item has been deleted.
}

class TableViewCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()
    
    var originalCentre = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    
    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()
    
    var delegate: TableViewCellDelegate?    /// The object that acts as delegate for this cell.
    var toDoItem: ToDoItem? {                 /// The item that this cell renders.
        didSet {
            label.text = toDoItem!.text
            //label.strikeThrough = (toDoItem?.completed)!
            //itemCompleteLayer.isHidden = !label.strikeThrough
        }
    }
    
    var tableIndex: IndexPath?

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        selectionStyle = .none
        
        ///Set gradient layer for cell
        
        gradientLayer.frame = bounds
        
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor
        let color3 = UIColor.clear.cgColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.2,0.8, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor.lightGray.cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    let labelLeftMargin: CGFloat = 15.0
    
    override func layoutSubviews () {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: labelLeftMargin, y: 0, width: bounds.size.width - labelLeftMargin, height: bounds.size.height)
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
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
        }
        // 3:  Check the flag to see if the action was a delete or not
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if delegate != nil && toDoItem != nil {
                    delegate!.toDoItemDeleted(todoItem: toDoItem!, index: tableIndex!)
                }
            } else if completeOnDragRelease {
                toDoItem?.completed = true
                //completeOnDragRelease = false
                label.strikeThrough = true
                itemCompleteLayer.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
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

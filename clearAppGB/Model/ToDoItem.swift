//
//  ToDoItem.swift
//  clearAppGB
//
//  Created by Gavin Butler on 2018-04-29.
//  Copyright © 2018 Gavin Butler. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {

    var text: String
    
    var completed: Bool
    
    init (text: String) {
        
        self.text = text
        self.completed = false
    }
    
}

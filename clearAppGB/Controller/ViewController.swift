//
//  ViewController.swift
//  clearAppGB
//
//  Created by Gavin Butler on 2018-04-29.
//  Copyright © 2018 Gavin Butler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems = [ToDoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor.black
        
        if toDoItems.count == 0 {
            toDoItems.append(ToDoItem(text: "feed the cat"))
            toDoItems.append(ToDoItem(text: "buy eggs"))
            toDoItems.append(ToDoItem(text: "watch WWDC videos"))
            toDoItems.append(ToDoItem(text: "rule the Web"))
            toDoItems.append(ToDoItem(text: "buy a new iPhone"))
            toDoItems.append(ToDoItem(text: "darn holes in socks"))
            toDoItems.append(ToDoItem(text: "write this tutorial"))
            toDoItems.append(ToDoItem(text: "master Swift"))
            toDoItems.append(ToDoItem(text: "learn to draw"))
            toDoItems.append(ToDoItem(text: "get more exercise"))
            toDoItems.append(ToDoItem(text: "catch up with Mom"))
        }
    }
    
    ///TableView datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        ///Gets rid of the highlighting that happens when you select a table cell
        //cell.selectionStyle = .none
        
        //cell.textLabel?.backgroundColor = UIColor.clear
        //cell.textLabel?.text = toDoItems[indexPath.row].text
        cell.tableIndex = indexPath
        cell.delegate = self
        cell.toDoItem = toDoItems[indexPath.row]
        return cell
    }
    
    ///TableView delegate methods
    
    ///Not required - don't want to highlight cell when pressed 
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    ///Set cell background colour with gradation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
    ///Included only for prior to IOS 8.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }

}

extension ViewController {
    
    func toDoItemDeleted(todoItem: ToDoItem, index: IndexPath) {
        toDoItems.remove(at: index.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [index], with: .fade)
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    ///Utility functions:
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
}


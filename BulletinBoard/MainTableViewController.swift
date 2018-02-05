//
//  MainTableViewController.swift
//  BulletinBoard
//
//  Created by Christopher Thiebaut on 2/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var messageTextField: UITextField!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Listen for message and act accordingly.
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NotificationKeys.messagesUpdated, object: nil)
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        // Configure the cell...
        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = dateFormatter.string(from: message.date)

        return cell
    }
 
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let text = messageTextField.text, !text.isEmpty else {
            return
        }
        messageTextField.text = nil
        MessageController.shared.saveNewMessage(withText: text)
    }
    
    @objc private func updateTable(){
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.messageTextField.text = nil
        }
    }
}

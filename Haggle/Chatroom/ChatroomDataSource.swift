//
//  ChatroomDataSource.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/16/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit


class ChatroomDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var messages: [Message] = []
    
    override init() {
        super.init()
    }
    
    func update(with messages: [Message]) {
        
        // immediately append latest message if theres a single message incoming. Theres probably a better way. See `latestMessage` property in ChatroomViewModel for implementation. 
        
        if messages.count == 1 {
            self.messages.append(messages[0])
        } else {
            self.messages = messages
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.ownerId == AuthService.shared.currentUser.id {
            let outgoingCell = Bundle.main.loadNibNamed("OutgoingMessageCell", owner: nil, options: nil)?.first as! OutgoingMessageCell
            let vm = MessageCellViewModel(message)
            outgoingCell.prepare(with: vm)
            return outgoingCell
        }
        else {
            let incomingCell = Bundle.main.loadNibNamed("IncomingMessageCell", owner: nil, options: nil)?.first as! IncomingMessageCell
            let vm = MessageCellViewModel(message)
            incomingCell.prepare(with: vm)
            return incomingCell
        }
    }

}


//
//  MyAccountDataSource.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/26/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class MyAccountDataSource: NSObject, UITableViewDataSource {

    private let dataSource = [
        ["Terms of Service", "Feedback", "Logout", "Delete Account"],
        [#imageLiteral(resourceName: "terms"), #imageLiteral(resourceName: "feedback"), #imageLiteral(resourceName: "logout"), #imageLiteral(resourceName: "delete")]
    ]
    
    
    override init () {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as! MyAccountCell
        
        cell.titleLabel.text = dataSource[0][indexPath.row] as? String
        cell.iconImageView.image = dataSource[1][indexPath.row] as? UIImage
        
        return cell
    }
    
}

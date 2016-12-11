//
//  ViewController.swift
//  TextFieldValidator
//
//  Created by Khemmachart Chutapetch on 12/10/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data: [IndexPath: String] = [:]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableViewProperties()
    }
    
    func setTableViewProperties() {
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func validateSuccessCallback(indexPath: IndexPath) -> ((_ text: String, _ desc: String) -> Void) {
        return { (text, resultDesc) in
            self.data[indexPath] = text
        }
    }
    
    func validateFailedCallback(indexPath: IndexPath) -> ((_ text: String, _ desc: String) -> Void) {
        return { (text, resultDesc) in
            self.data[indexPath] = text
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValidatorCell", for: indexPath) as! TextFieldValidatorTableViewCell
        cell.validateSuccessCallback = validateSuccessCallback(indexPath: indexPath)
        cell.validateFailedCallback  = validateFailedCallback(indexPath: indexPath)
        cell.textField.text = data[indexPath]
        cell.editedFlag = data[indexPath] != nil
        
        switch indexPath.row {
        case 0:
            cell.validatorCellType = .UsernameCell
        case 1:
            cell.validatorCellType = .PasswordCell
        case 2:
            cell.validatorCellType = .EmailCell
        case 3:
            cell.validatorCellType = .Firstname
        default:
            cell.validatorCellType = .None
        }
        
        return cell
    }
}


//
//  formTableViewCell.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit

class userInputField : UITextField {
    private var val : Int?
    var userInputdelegate: userInputFieldDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addTarget(self, action: #selector(doTheThing), for: .editingChanged)
        //self.addTarget(self, action: #selector(doTheOtherThing), for: .editingChanged)
        self.clearButtonMode = .whileEditing
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(doTheThing), for: .editingChanged)
        //self.addTarget(self, action: #selector(doTheOtherThing), for: .editingChanged)
        self.clearButtonMode = .whileEditing
    }
    
    func doTheThing(){
        userInputdelegate?.userInputFieldDidChange(userInputField: self)
    }
}

class formTableViewCell : UITableViewCell {
    var formTextField = userInputField()
    var row : Int?
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpFormTextField(){
        formTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(formTextField)
        formTextField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        formTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        formTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        formTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        formTextField.backgroundColor = LoginRegisterViewController.defaultGray
        formTextField.borderStyle = UITextBorderStyle.roundedRect
    }
}

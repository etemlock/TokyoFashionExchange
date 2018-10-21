//
//  addPreferencesViewController.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit

class addPreferencesViewController: UIViewController {
    
    @IBOutlet var prefTextView: UITextView!
    
    var prevPageInputs : registerInputWrapper?
    
    /*init(registerParams: registerInputWrapper) {
        super.init(nibName: nil, bundle: nil)
        self.prevPageInputs = registerParams
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefTextView.layer.borderWidth = 2
        prefTextView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

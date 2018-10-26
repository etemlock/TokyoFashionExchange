//
//  ViewController.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import UIKit
import Foundation

class LoginRegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate  {
    /**** view ****/
    @IBOutlet var logoImage: UIImageView!
    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    @IBOutlet var formTableView: UITableView!
    private var segmentIndexFlag = 0
    private var loginPlaceHolders = ["ユーザネーム","パースワード"]
    private var registerPlaceHolders = ["ユーザネーム","住所","年","メールアド","パスワード","パスワード確認"]
    
    
    /**** data *****/
    private var cellId = "formTableCell"
    var regSegue = "continueRegistrationSegue"
    private var loginInputs = loginInputWrapper()
    private var registerInputs = registerInputWrapper()
    
    
    static var defaultGray = UIColor(red: 229/255, green: 226/255, blue: 233/255, alpha: 1)
    static var themeColor = UIColor(red: 24/255, green: 139/255, blue: 255/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: cellId)
        formTableView.delegate = self
        formTableView.dataSource = self
        logoImage.image = UIImage(named: "Jacket")
        registerButton.isHidden = true
        genderSegment.isHidden = true
        self.hideKeyBoardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /***************** view init *******************************/
    func setUpLoginButtonConstraints() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        loginButton.topAnchor.constraint(equalTo: formTableView.topAnchor, constant: 100)
        loginButton.heightAnchor.constraint(equalToConstant: 30)
        loginButton.widthAnchor.constraint(equalToConstant: 135)
        self.view.bringSubview(toFront: loginButton)
    }
    
    /**************** tableView functions **********************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndexFlag == 0 {
            return 2
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! formTableViewCell
        cell.contentView.layoutIfNeeded()
        cell.setUpFormTextField()
        cell.formTextField.userInputdelegate = self
        cell.row = indexPath.row
        if segmentIndexFlag == 0 {
            cell.formTextField.placeholder = loginPlaceHolders[indexPath.row]
            cell.formTextField.text = loginInputs.getInput(pos: indexPath.row)
        } else {
            cell.formTextField.placeholder = registerPlaceHolders[indexPath.row]
            cell.formTextField.text = registerInputs.getInput(pos: indexPath.row)
        }
        return cell
    }
    
    @IBAction func changeIndex(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndexFlag = 0
            genderSegment.isHidden = true
            registerButton.isHidden = true
            loginButton.isHidden = false
        case 1:
            segmentIndexFlag = 1
            genderSegment.isHidden = false
            registerButton.isHidden = false
            loginButton.isHidden = true
        default:
            segmentIndexFlag = 0
        }
        formTableView.reloadData()
    }
    
    @IBAction func selectGender(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex {
        case 0:
            registerInputs.setInput(input: "女", pos: 6)
        case 1:
            registerInputs.setInput(input: "男", pos: 6)
        default:
            registerInputs.setInput(input: "女", pos: 6)
        }
    }
    
    
    /******************* userInputDelegate *******************/
    func userInputFieldDidChange(userInputField: userInputField) {
        if let parentCell = userInputField.superview?.superview as? formTableViewCell {
            let row = parentCell.row
            if segmentIndexFlag == 0 {
                loginInputs.setInput(input: userInputField.text!, pos: row!)
            } else {
                registerInputs.setInput(input: userInputField.text!, pos: row!)
            }
        }
    }
    
    /************************************ button actions **************************************/
    
    @IBAction func registerClick(_ sender: Any) {
        for i in 0...6 {
            if registerInputs.getInput(pos: i) == "" {
                promptAlertWithDelay("インプット足りない", inmessage: "インプット全部入れてください", indelay: 5.0)
                return
            }
        }
        if registerInputs.getPasswd() != registerInputs.getPasswdCfrm() {
            promptAlertWithDelay("パスワードが合いません", inmessage: "パスワードが合いません", indelay: 5.0)
            return
        }
        performSegue(withIdentifier: regSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem?.title = "< Back"
        if let nextView = segue.destination as? addPreferencesViewController {
            if segue.identifier == regSegue {
                nextView.setPrevPageInputs(registerParams: registerInputs)
            }
        }
    }

}

class loginInputWrapper {
    private var loginInputs : [String] = ["",""]
    
    func setInput(input: String, pos: Int){
        if 0...1 ~= pos {
            loginInputs[pos] = input
        }
    }
    
    func getInput(pos: Int) -> String {
        if 0...1 ~= pos {
            return loginInputs[pos]
        }
        return ""
    }
}

class registerInputWrapper {
    private var registerInputs : [String] = ["","","","","","","女"]
    
    func setInput(input: String, pos: Int){
        if 0...6 ~= pos {
            registerInputs[pos] = input
        }
    }
    
    func getInput(pos: Int) -> String {
        if 0...6 ~= pos {
            return registerInputs[pos]
        }
        return ""
    }
    
    func getPasswd() -> String {
        return registerInputs[4]
    }
    
    func getPasswdCfrm() -> String {
        return registerInputs[5]
    }
}


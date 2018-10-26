//
//  addPreferencesViewController.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit


class addPreferencesViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var prefTextView: UITextView!
    
    @IBOutlet var sizePickerView: UIPickerView!
    
    private var segueId = "toUploadPicSegue"
    /****** data ******/
    private var sizePickerData = ["S (３０〜４５cm)","M　(４５〜６０cm）","L（６０〜８０cm）"]
    var sizes = ["S","M","L"]
    var selectSize = "M"
    let userURL = "https://tokyofashionexchange.firebaseio.com/"
    private var userToRegister = userModel()
    
    
    //Needs to evenutally be made private
    private var prevPageInputs : registerInputWrapper?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if prevPageInputs == nil {
            return
        }
        prefTextView.layer.borderWidth = 2
        prefTextView.layer.borderColor = UIColor.darkGray.cgColor
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        self.hideKeyBoardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPrevPageInputs(registerParams: registerInputWrapper){
        self.prevPageInputs = registerParams
    }
    
    /******************* UITextView delegate functions *******************/
    
    
    /******************* pickerView delegate functions ********************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectSize = sizes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizePickerData[row]
    }
    
    /****************************** UIButton Actions ****************************/
    @IBAction func registerUser(_ sender: Any) {
        setUserAttributesFromPrevParams()
        userToRegister.size = selectSize
        userToRegister.favoriteBrand = getBrandList()
        self.performSegue(withIdentifier: self.segueId, sender: self)
        fireBase().saveUserBlobToFireBase(url: userURL, userToPost: userToRegister, completion: {(didSucceed) in
            if(didSucceed){
                self.performSegue(withIdentifier: self.segueId, sender: self)
            } else {
                self.promptAlertWithDelay("", inmessage: "登録が失敗しました", indelay: 5.0)
            }
        })
    }
    
    func setUserAttributesFromPrevParams() {
        for i in 0...5 {
            if let param = self.prevPageInputs?.getInput(pos: i){
                switch i {
                case 0:
                    userToRegister.name = param
                case 1:
                    userToRegister.address = param
                case 2:
                    userToRegister.age = param
                case 3:
                    userToRegister.email = param
                case 5:
                    userToRegister.password = param
                case 6:
                    if param == "女" {
                        userToRegister.sex = 0
                    } else {
                        userToRegister.sex = 1
                    }
                default:
                    break
                }
            }
        }
    }
    
    func getBrandList() -> [String] {
        return prefTextView.text.components(separatedBy: ",")
    }
    
    
}

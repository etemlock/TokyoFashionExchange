//
//  Extensions.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func promptAlertWithDelay(_ intitle: String,  inmessage: String, indelay: Double){
        let alert = UIAlertController(title: intitle, message: inmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + indelay
        DispatchQueue.main.asyncAfter(deadline: time){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension Date {
    func convertDateToString() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func convertStringToDate() -> Date? {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}

//
//  delegateMethods.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/21/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit

protocol userInputFieldDelegate {
    func userInputFieldDidChange(userInputField: userInputField)
}

protocol imageCellButtonDelegate {
    func imageCellButtonWasPressed(quadrant: Int)
}


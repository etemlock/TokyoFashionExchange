//
//  imageCollectionViewCell.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/26/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit

class imageCollectionViewCell : UICollectionViewCell {
    @IBOutlet var cellImage: UIImageView!
    
   // @IBOutlet var uploadButton: UIButton!

    var cellButtonDelegate : imageCellButtonDelegate?
    
    var quadrant: Int = 0
    //var image : UIImage?
    

    @IBAction func onClickEvent(_ sender: Any) {
        cellButtonDelegate?.imageCellButtonWasPressed(quadrant: self.quadrant)
    }
    


    
}

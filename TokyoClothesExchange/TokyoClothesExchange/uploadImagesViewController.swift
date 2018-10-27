//
//  uploadImagesViewController.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/26/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
import Photos

class uploadImagesViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, imageCellButtonDelegate {
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    var imgPicker = UIImagePickerController()
    
    /******* data *********/
    var cellId = "uploadImageCell"
    var quadrantToSetImg : Int = 0
    var imageArray : [UIImage?] = [nil,nil,nil,nil]
    var imageNameArray : [String?] = [nil,nil,nil,nil]
    var imageURLArray : [URL?] = [nil,nil,nil,nil]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.isScrollEnabled = false
        imgPicker.delegate = self
        self.hideKeyBoardWhenTappedAround()
        //print("\(Auth.auth().currentUser?.uid)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /************************ collectionViewDelegate functions ************************/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! imageCollectionViewCell
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.cellButtonDelegate = self
        cell.quadrant = indexPath.item
        return cell
    }
    
    
    /*************************** UIImagePickerController functions *******************************/
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let cell = imageCollectionView.cellForItem(at: IndexPath(item: quadrantToSetImg, section: 0)) as! imageCollectionViewCell
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cell.cellImage.contentMode = .scaleAspectFit
            cell.cellImage.image = chosenImage
            imageArray[quadrantToSetImg] = chosenImage
        } else {
            print("couldn't load image for quadrant \(quadrantToSetImg)")
        }
        if let chosenURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            imageURLArray[quadrantToSetImg] = chosenURL as URL
        } else {
            print("could get image url for quadrant \(quadrantToSetImg)")
        }

        
        dismiss(animated: true, completion: nil)
    }
    
    /******************** button events *********************/
    
    func imageCellButtonWasPressed(quadrant: Int) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        quadrantToSetImg = quadrant
        self.present(imgPicker, animated: true, completion: nil)
        
        //implement later
    }
    
    @IBAction func uploadPhotosToStorage(_ sender: Any) {
        DispatchQueue.global(qos: .background).async {
            fireBase().uploadImagesToStorage(images: self.imageArray, localURLs: self.imageURLArray)
        }
        
    }
}

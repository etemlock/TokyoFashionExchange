//
//  Firebase.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/24/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class fireBase {
    private var ref : DatabaseReference?
    private var categoryURL = "https://us-central1-tokyofashionexchange.cloudfunctions.net/item_tagging_category"
    private var colorURL = "https://us-central1-tokyofashionexchange.cloudfunctions.net/item_tagging_color"


    func firstFireBaseFunc(url: String){
        let ref = Database.database().reference(fromURL: url)
        ref.child("heroes").updateChildValues(["testValue2":1234])
    }
    
    func saveUserBlobToFireBase(url: String, userToPost: userModel, completion: @escaping (_ didSucceed: Bool) -> Void)  {
        ref = Database.database().reference(fromURL: url)
        let date = Date()
        Auth.auth().createUser(withEmail: userToPost.email, password: userToPost.password, completion: {(AuthResultCallback) in
            //check for error
            if let error = AuthResultCallback.1 {
                print("\(error)")
                completion(false)
            }
            //else check for user
            if let user = AuthResultCallback.0 {
                let uid = user.uid
                let post : [String: Any] = [
                    "address":userToPost.address,
                    "age":userToPost.age,
                    "favoriteBrands": userToPost.favoriteBrand,
                    "favoriteColors" : [String](),
                    "size": userToPost.size,
                    "sex": userToPost.sex,
                    "name" : userToPost.name,
                    "userId" : uid,
                    "createDate": date.convertDateToString(),
                    "updateDate": ""
                ]
                self.ref?.child("users").child(uid).updateChildValues(post, withCompletionBlock:{ (err,ref)  in
                    if err != nil {
                        print("\(err)")
                        completion(false)
                    }
                    print("sucessfully inserter user with the params \(post)")
                    completion(true)
                })
                
            }
        })
        return
    }
    
    func saveItemBlobToFireBase(url: String, itemToPost: itemModel, completion: @escaping (_ didSuceed: Bool) -> Void ){
        ref = Database.database().reference(fromURL: url)
        guard let user = Auth.auth().currentUser else {
            print("couldn't get current user from firebase")
            completion(false)
            return
        }
        
        let userId = user.uid
        ref?.child("users").child(userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let user = snapshot.value as? [String:Any] {
                let key = self.ref?.child("items").childByAutoId().key
                let post : [String: Any] = [
                    "publishUID" : userId,
                    "photoURLString": itemToPost.photoURLString,
                    "categories": itemToPost.categories,
                    "colors": itemToPost.colors,
                    "size": user["size"] ?? "",
                    "brand": "",
                    "getterUserID": "",
                    "itemID": key ?? ""
                ]
                print("\(post)")
                self.ref?.child("items").child(key!).updateChildValues(post, withCompletionBlock: { (err,ref) in
                    if err != nil {
                        print("\(err)")
                        completion(false)
                    }
                    print("sucessfully inserter item with the params \(post)")
                    completion(true)
                })
            } else {
                completion(false)
            }
        })
        return
        
        
    }

    
    /*func setItemModel() -> Error? {
        var retItem = itemModel()
        guard let user = Auth.auth().currentUser else {
            return Error()
        }
        user.u
        
    }*/
    
    
    func uploadImagesToStorage(images: [UIImage?], localURLs: [URL?]){
        let storageRef = Storage.storage().reference()
        for image in images {
            if image != nil {
                uploadSingleImageToStorage(storageRef: storageRef, image: image!, completion: {(imageUrlStr) in
                    let itemToPost = itemModel()
                    self.makeRequestToCloudVisionAPI(targetURLString: self.categoryURL,imageURLString: imageUrlStr, completion: {
                        (jsonCtg, errStrCtg) in
                        if errStrCtg != nil {
                            print(errStrCtg ?? "")
                        }
                        if jsonCtg != nil {
                            itemToPost.photoURLString = imageUrlStr!
                            itemToPost.categories = self.getTagsFromAnnotations(jsonArray: jsonCtg!)
                        }
                        
                        
                        //do the Color request after the Category request
                        self.makeRequestToCloudVisionAPI(targetURLString: self.colorURL, imageURLString: imageUrlStr, completion: {
                            (jsonClr, errStrClr) in
                            if errStrClr != nil {
                                print(errStrClr ?? "")
                            }
                            if jsonClr != nil {
                                itemToPost.colors = self.getColorsFromAnnotations(jsonArray: jsonClr!)
                            }
                            self.saveItemBlobToFireBase(url: "https://tokyofashionexchange.firebaseio.com/", itemToPost: itemToPost, completion: { (success) in
                                     print("success: \(success)")
                                })
                        })
                    })
                })
            }
        }
    }
    
    func uploadSingleImageToStorage(storageRef: StorageReference, image: UIImage, completion: @escaping (_ imageUrlString : String?) -> Void ){
        let storeImageRef = storageRef.child("Images/" + NSUUID().uuidString + ".jpeg")
        if let uploadData = UIImagePNGRepresentation(image){
            storeImageRef.putData(uploadData, metadata: nil, completion: { (metaData, errorL1) in
                if errorL1 != nil {
                    print("\(errorL1)")
                    completion(nil)
                }
                storeImageRef.downloadURL(completion: {
                    (url, errorL2) in
                    if errorL2 != nil {
                        print("\(errorL2)")
                        completion(nil)
                    } else if let urlStr = url?.absoluteString {
                        completion(urlStr)
                    }
                })
            })
        }
    }
    
    func makeRequestToCloudVisionAPI(targetURLString: String, imageURLString: String?, completion: @escaping (_ jsonResults: [[String:AnyObject]]?, _ errorDesc: String?) -> Void){
        guard imageURLString != nil else {
            print("imageURLString was nil")
            return
        }
        
        if let apiUrl = URL(string: targetURLString){
            var apiURLRequest = URLRequest(url: apiUrl)
    
            let postDataString = "imageURL=" + imageURLString!
            guard let postData = postDataString.data(using: String.Encoding.utf8) else {
                print("couldn't convert firebase storage url into valid data")
                return
            }

            apiURLRequest.httpMethod = "POST"
            apiURLRequest.httpBody = postData
            apiURLRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: apiURLRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    print("error: \(error)")
                    completion(nil,error?.localizedDescription)
                    return
                }
                if data != nil {
                    do {
                        if let jsonRes = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:AnyObject]] {
                            if targetURLString == self.categoryURL {
                                if let responses = jsonRes[0]["responses"] as? [[String:AnyObject]]{
                                    if let labelAnnotations = responses[0]["labelAnnotations"] as? [[String:AnyObject]]{
                                        completion(labelAnnotations, nil)
                                    }
                                }
                            } else if targetURLString == self.colorURL {
                                guard let responses = jsonRes[0]["responses"] as? [[String:AnyObject]] else {
                                    completion(nil,"couldn't retrieve responses from jsonRes")
                                    return
                                }
                                guard let imageProps = responses[0]["imagePropertiesAnnotation"] as? [String:AnyObject] else {
                                    completion(nil,"couldn't retrieve imagePropertiesAnnotation from responses")
                                    return
                                }
                                guard let domColors = imageProps["dominantColors"] as? [String:AnyObject] else {
                                    completion(nil,"couldn't retrieve dominantColors from imagePropertiesAnnotation")
                                    return
                                }
                                if let colors = domColors["colors"] as? [[String:AnyObject]]{
                                    completion(colors, nil)
                                    return
                                } else {
                                    completion(nil,"couldn't retrieve colors from dominantColors")
                                }
                            }
                        }
                    } catch let error {
                        let errStr = "JSONSerialization error : \(error.localizedDescription)"
                        completion(nil,errStr)
                    }
                }
                
            })
            dataTask.resume()
        }
    }
    
    func getTagsFromAnnotations(jsonArray: [[String: AnyObject]]) -> [String] {
        var descriptions : [String] = []
        for obj in jsonArray {
            if let score = obj["score"] as? Float {
                if score > 0.6 {
                    if let description = obj["description"] as? String {
                        descriptions.append(description)
                    }
                }
            }
        }
        return descriptions
    }
    
    func getColorsFromAnnotations(jsonArray: [[String: AnyObject]]) -> [String] {
        var colors : [String] = []
        for obj in jsonArray {
            if let score = obj["score"] as? Float {
                if score > 0.15 {
                    if let colorObj = obj["color"] as? [String:Int] {
                        let redVal = colorObj["red"]
                        let greenVal = colorObj["green"]
                        let blueVal = colorObj["blue"]
                        let color = "\(redVal!).\(greenVal!).\(blueVal!)"
                        colors.append(color)
                    }
                }
            }
        }
        return colors
    }
    
    
    
    
}

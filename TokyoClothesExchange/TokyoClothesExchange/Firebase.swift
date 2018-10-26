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
    
    func uploadImagesToStorage(images: [UIImage?], localURLs: [URL?]){
        let storageRef = Storage.storage().reference()
        for image in images {
            if image != nil {
                uploadSingleImageToStorage(storageRef: storageRef, image: image!, completion: {(metaData) in
                    print("\(metaData)")
                })
            }
        }
        
    }
    
    func uploadSingleImageToStorage(storageRef: StorageReference, image: UIImage, completion: @escaping (_ metaData : StorageMetadata?) -> Void ){
        let toPutRef = storageRef.child("Images/Image1.jpg")
        if let uploadData = UIImagePNGRepresentation(image){
            toPutRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print("\(error)")
                    completion(nil)
                }
                
                completion(metaData)
            })
        }
        
    }
    
}

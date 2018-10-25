//
//  Firebase.swift
//  TokyoClothesExchange
//
//  Created by Eugene  Temlock on 10/24/18.
//  Copyright © 2018 Team Messi. All rights reserved.
//

import Foundation
import Firebase


class fireBase {
    private var ref : DatabaseReference?

    func firstFireBaseFunc(url: String){
        let ref = Database.database().reference(fromURL: url)
        ref.child("heroes").updateChildValues(["testValue2":1234])
    }
    
    func saveUserBlobToFireBase(url: String, userToPost: userModel) -> Bool {
        ref = Database.database().reference(fromURL: url)
        let date = Date()
        var success : Bool = false
        Auth.auth().createUser(withEmail: userToPost.email, password: userToPost.password, completion: {(AuthResultCallback) in
            //check for error
            if let error = AuthResultCallback.1 {
                print("\(error)")
                return
            }
            //else check for user
            if let user = AuthResultCallback.0 {
                let uid = user.uid
                let post : [String: Any] = [
                    "address":userToPost.address,
                    "age":userToPost.age,
                    "favoriteBrands": userToPost.favoriteBrand,
                    "favoriteColors" : [String](),
                    "userID" : "",
                    "size": userToPost.size,
                    "sex": userToPost.sex,
                    "name" : userToPost.name,
                    "userId" : uid,
                    "createDate": date.convertDateToString(),
                    "updateDate": ""
                ]
                self.ref?.child("testUser").child(uid).updateChildValues(post, withCompletionBlock:{ (err,ref)  in
                    if err != nil {
                        print("\(err)")
                        return
                    }
                    print("sucessfully inserter user with the params \(post)")
                    success = true
                })
                
            }
        })
        return success
    }
    
    
}

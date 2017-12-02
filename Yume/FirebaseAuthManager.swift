//
//  FirebaseAuthManager.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAuthManager {
    //MARK: - 匿名としてログイン
    func signInAnonymously(vc: StartViewController) {
        Auth.auth().signInAnonymously(completion: { (user: User?, error: Error?) in
            if let err = error {
                vc.failedSignInAnonymously(message: err.localizedDescription)
                return
            }
            if let user = user {
                let userLoginTypeDescriptionText = user.isAnonymous ? "Anonymous": user.email ?? "user isnt Anonymous but has no email."
                print("userを取得しました. uid: \(user.uid), type: \(userLoginTypeDescriptionText)")
                
                // データのload
                vc.successSignInAnonymously()
            } else {
                vc.failedSignInAnonymously(message: "userを取得できませんでした")
            }
        })
    }
    
}

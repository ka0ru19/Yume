//
//  FirebaseDatabaseManager.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDatabaseManager {
    
    let rootRef = Database.database().reference()
    let fireUser: User? = Auth.auth().currentUser
    
    // MARK: - 取得
    func getArcitleArray(vc: ReadViewController) {
        // Firebaseのデータベースにアクセスする下準備
        //        guard let uid = fireUser?.uid else { return }
        let postListRef = rootRef.child("post-list")
        
        // リクエストを送信
        postListRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let valueArray = snapshot.value as? [String: AnyObject] else {
                vc.failedGetArcitleArray(message: "snapshot.valueを[String: AnyObject]に変換できなかったため")
                return // このブロックを抜ける
            }
            print("取得完了: valueArray: -> \(valueArray)")
            
            var tempDictArray: [Dictionary<String, AnyObject>] = []
            for v in valueArray {
                guard let dict = v.value as? Dictionary<String, AnyObject> else { continue }
                tempDictArray.append(dict)
            }
            vc.successLoadDictArray(dictArray: tempDictArray)
            tempDictArray.removeAll(keepingCapacity: true)
        })
    }
    
    // MARK: - : 本人の直近の投稿を取得
    func getRecentPost(vc: ArchiveViewController) {
        // Firebaseのデータベースにアクセスする下準備
        guard let uid = fireUser?.uid else { return }
        let recentPostIdRef = rootRef.child("user-list").child(uid).child("recent-postId")
        let postListRef = rootRef.child("post-list")
        
        // リクエストを送信
        recentPostIdRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? String else {
                //                vc.failedGetArcitleArray(message: "snapshot.valueを[String: AnyObject]に変換できなかったため")
                return // このブロックを抜ける
            }
            print("取得完了: value: -> \(value)")
            
            let pid: String = value
            
            postListRef.child(pid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let valueDict = snapshot.value as? Dictionary<String, AnyObject> else {
//                    vc.failedGetArcitleArray(message: "snapshot.valueを[String: AnyObject]に変換できなかったため")
                    return // このブロックを抜ける
                }
                print("取得完了: valueArray: -> \(valueDict)")
                
                vc.successLoadRecentPost(dict: valueDict)
            })
        })
        
        //        postListRef.observeSingleEvent(of: .value, with: { (snapshot) in
        //            guard let valueArray = snapshot.value as? [String: AnyObject] else {
        //                vc.failedGetArcitleArray(message: "snapshot.valueを[String: AnyObject]に変換できなかったため")
        //                return // このブロックを抜ける
        //            }
        //            print("取得完了: valueArray: -> \(valueArray)")
        //
        //            var tempDictArray: [Dictionary<String, AnyObject>] = []
        //            for v in valueArray {
        //                guard let dict = v.value as? Dictionary<String, AnyObject> else { continue }
        //                tempDictArray.append(dict)
        //            }
        //            vc.successLoadDictArray(dictArray: tempDictArray)
        //            tempDictArray.removeAll(keepingCapacity: true)
        //        })
    }
    
    // MARK: - 投稿
    func postNewArcitle(newValue: [String:String], vc: InputViewController){
        guard let uid = fireUser?.uid else {
            vc.failedGetArcitleArray(message: "post faild because no uid.")
            return
        }
        
        let userPostIdListRef = rootRef.child("user-list").child(uid).child("postId-list")
        
        let newRef = userPostIdListRef.childByAutoId()
        let newKey = newRef.key // 新しいpouid.stId
        
        // postId-listにpostIdを追加
        userPostIdListRef.childByAutoId().setValue(newKey)
        
        // user-listのrecent-postIdのpostIdを更新
        rootRef.child("user-list").child(uid).child("recent-postId").setValue(newKey)
        
        let newValueWithKey = newValue.union(other: ["uid": uid]).union(other: ["self-postId": newKey])
        
        let postIdListRef = rootRef.child("post-list")
        postIdListRef.child(newKey).setValue(newValueWithKey, withCompletionBlock: {(error: Error?, ref) in
            if let err = error {
                // 失敗
                vc.failedGetArcitleArray(message: err.localizedDescription)
            } else {
                // 成功
                vc.successPostNewArcitle()
            }
        })
    }
    
    // MARK: - : 閲覧履歴を更新(postId, いいねしたか否か, vc)
    func setLooked(pid: String, isLiked: Bool, vc: ReadViewController) {
        // Firebaseのデータベースにアクセスする下準備
        guard let uid = fireUser?.uid else { return }
        let postListRef = rootRef.child("post-list")
        
        let dict = [
            "isLiked": isLiked ? "true" : "false",
            "uid": uid,
            ]
        // リクエストを送信
        postListRef.child(pid).child("looked-list").childByAutoId().setValue(dict, withCompletionBlock: {(error: Error?, ref) in
            if let err = error {
                // 失敗
                vc.failedSetLooked(message: err.localizedDescription)
            } else {
                // 成功
                vc.successSetLooked()
            }
        })
    }
}

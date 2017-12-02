//
//  ReadViewController.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {
    
    @IBOutlet weak var dreamImageView: UIImageView!
    @IBOutlet weak var dreamTextView: UITextView!
    
    var postDictArray: [Dictionary<String, AnyObject>] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dreamTextView.isEditable = false
        
        // Do any additional setup after loading the view.
        
        FirebaseDatabaseManager().getArcitleArray(vc: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedHome(_ sender: UIButton) {
        gobackToHome()
    }
    
    
    
    @IBAction func onTappedNext(_ sender: UIButton) {
        index += 1
        display()
    }
    
    @IBAction func onTappedLike(_ sender: UIButton) {
        
    }
    
    func gobackToHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setDisplayDict(postDictArray: [Dictionary<String, AnyObject>]) {
        self.postDictArray = postDictArray
        index = 0
        display()
    }
    
    func display() {
        if (index < postDictArray.count) {
            dreamTextView.text = postDictArray[index]["text"] as? String ?? "no text"
        } else {
            print("indexがpostDictArray.countを超えたよ")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ReadViewController {
    func failedGetArcitleArray(message: String) {
        print(message)
    }
    
    func successLoadDictArray(dictArray: [Dictionary<String, AnyObject>]) {
        
        var tempDictArray: [Dictionary<String, AnyObject>] = [] // シャッフルするのに一時的に使うdictArray
        var postDictArray: [Dictionary<String, AnyObject>] = [] // dictArray
        
        // 本人のuid
        guard let selfUid = FirebaseDatabaseManager().fireUser?.uid else { return }
        
        for dict in dictArray {
            // 本人の投稿なら表示しない
            guard let _uid = dict["uid"] as? String else { continue }
            if _uid == selfUid { continue }
            
            // 他人の投稿でも既にみた投稿は表示しない
            var isLookedPost = false
            if let _lookedListArray = dict["looked-list"] as? [AnyObject] {
                for _lookedList in _lookedListArray {
                    guard let _lookedUid = _lookedList["uid"] as? String else { continue }
                    if _lookedUid == selfUid {
                        isLookedPost = true
                        break
                    }
                }
            }
            // まだ見てない投稿だったら
            if !isLookedPost {
                tempDictArray.append(dict)
            }
        }
        
        // 配列をシャッフル
        while (tempDictArray.count > 0) {
            let randomNumber = Int(arc4random_uniform(UInt32(tempDictArray.count)))
            postDictArray.append(tempDictArray[randomNumber])
            tempDictArray.remove(at: randomNumber)
        }
        print(postDictArray)
        
        setDisplayDict(postDictArray: postDictArray)
    }
}

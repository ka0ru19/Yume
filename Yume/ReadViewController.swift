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
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var postDictArray: [Dictionary<String, AnyObject>] = []
    var index: Int = 0
    var isLike : Bool = false {
        didSet {
            if isLike {
                self.likeButton.setImage(UIImage(named: "isLike1.png"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "isLike0.png"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dreamTextView.isEditable = false
        nextButton.isEnabled = false
        
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
        guard let pid = postDictArray[index]["self-postId"] as? String else { return }
        FirebaseDatabaseManager().setLooked(pid: pid, isLiked: isLike, vc: self)
        
        if index + 1 < postDictArray.count {
            index += 1
            display()
        } else {
            stopDisplay()
        }
    }
    
    @IBAction func onTappedLike(_ sender: UIButton) {
        isLike = !isLike
    }
    
    func gobackToHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setDisplayDict(postDictArray: [Dictionary<String, AnyObject>]) {
        self.postDictArray = postDictArray
        if self.postDictArray.count > 0 {
            display()
        } else {
            stopDisplay()
        }
    }
    
    func display() {
        isLike = false
        dreamTextView.text = postDictArray[index]["text"] as? String ?? "no text"
        nextButton.isEnabled = true
        
    }
    
    func stopDisplay() {
        dreamTextView.text = "しばらくしてからまた見てね"
        nextButton.isEnabled = true
    }
    
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
        print(selfUid)
        
        for dict in dictArray {
            // 本人の投稿なら表示しない
            guard let _uid = dict["uid"] as? String else { continue }
            if _uid == selfUid { continue }
            
            // 他人の投稿でも既にみた投稿は表示しない
            var isLookedPost = false
            if let _lookedListArray = dict["looked-list"]{
                guard let _lookedListDictArray = _lookedListArray as? [Dictionary<String, AnyObject>] else { continue }
                for _lookedListDict in _lookedListDictArray {
                    guard let _lookedUid = _lookedListDict["uid"] as? String else { continue }
                    print("_lookedUid")
                    print(_lookedUid)
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
        print("postDictArray")
        print(postDictArray)
        
        setDisplayDict(postDictArray: postDictArray)
    }
    
    
    func failedSetLooked(message: String) {
        print(message)
    }
    
    func successSetLooked() {
        
    }
}

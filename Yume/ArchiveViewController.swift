//
//  ArchiveViewController.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/03.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController {
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.isEditable = false
        FirebaseDatabaseManager().getRecentPost(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func display(dict: Dictionary<String, AnyObject>) {
        commentTextView.text = dict["text"] as? String ?? "no text"
        var likeCount = 0
        if let lookUidArray = dict["looked-list"] {
            guard let _lookUidArray = lookUidArray as? [String: AnyObject] else {return}
            for _lookUid in _lookUidArray {
                if _lookUid.value["isLiked"] as? String == "true" {
                    likeCount += 1
                }
             }
//            for lookUid in _lookUidArray {
//                guard let _lookUidLikedString = lookUid["isLiked"] as? String else {continue}
//                if _lookUidLikedString == "true" {
//                    likeCount += 1
//                }
//            }
        }
        likeCountLabel.text = String(likeCount)
        
        
    }
}

extension ArchiveViewController {
    func faildLoadRecentPost() {
        
    }
    
    func successLoadRecentPost(dict: Dictionary<String, AnyObject>) {
        print("successLoadRecentPost")
        print(dict)
        display(dict: dict)
    }
}

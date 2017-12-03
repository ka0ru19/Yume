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
        commentTextView.backgroundColor = UIColor.clear // 背景を透明に
        FirebaseDatabaseManager().getRecentPost(vc: self)
        
        animateStartButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateStartButton() {
        UIView.animate(withDuration: 1.0, animations: {
            
            self.commentImageView.frame.origin.y -= 5
            self.commentImageView.frame.size = CGSize(width: 380, height: 320)
            self.commentImageView.center.x = self.view.center.x
            self.commentImageView.alpha = 0.98
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.commentImageView.frame.origin.y += 5
                self.commentImageView.frame.size = CGSize(width: 360, height: 300)
                self.commentImageView.center.x = self.view.center.x
                self.commentImageView.alpha = 0.90
            }, completion: { _ in
                self.animateStartButton()
            })
        })
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

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
    
    let bgImageView = UIImageView()
    let waittingImageView = UIImageView()
    var bgImageIndex = 0
    var timer = Timer()
    
    let waittingImageArray: [UIImage] = [
        UIImage(named: "wait01.png")!,
        UIImage(named: "wait02.png")!,
        UIImage(named: "wait03.png")!,
        UIImage(named: "wait04.png")!,
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.frame = self.view.frame
        bgImageView.image = UIImage(named: "red_bg.png")
        
        
        waittingImageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        waittingImageView.center = bgImageView.center
        waittingImageView.contentMode = .scaleAspectFit
        waittingImageView.image = waittingImageArray.first
        
        bgImageView.addSubview(waittingImageView)
        self.view.addSubview(bgImageView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ArchiveViewController.updateImage), userInfo: nil, repeats: true)
        timer.fire()

        commentTextView.isEditable = false
        commentTextView.backgroundColor = UIColor.clear // 背景を透明に
        FirebaseDatabaseManager().getRecentPost(vc: self)
        
        animateStartButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateImage() {
        bgImageIndex += 1
        if bgImageIndex >= 4 {
            bgImageIndex = 0
        }
        waittingImageView.image = waittingImageArray[bgImageIndex]
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
        
        UIView.animate(withDuration: 3.0, animations: {
            self.bgImageView.alpha = 0.0
        }, completion: { _ in
            self.timer.invalidate()
            self.bgImageView.removeFromSuperview()
        })
        
        print("successLoadRecentPost")
        print(dict)
        display(dict: dict)
    }
}

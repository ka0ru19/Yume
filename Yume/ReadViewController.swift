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
    
    let bgImageView = UIImageView()
    let waittingImageView = UIImageView()
    var bgImageIndex = 0
    var timer = Timer()
    var sorryImageView = UIImageView()
    var sorryImageIndex = 0
    var timerSorry = Timer()
    
    let waittingImageArray: [UIImage] = [
        UIImage(named: "wait01.png")!,
        UIImage(named: "wait02.png")!,
        UIImage(named: "wait03.png")!,
        UIImage(named: "wait04.png")!,
        ]
    
    let sorryImageArray: [UIImage] = [
        UIImage(named: "sorry01.png")!,
        UIImage(named: "sorry02.png")!,
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
        
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ReadViewController.updateImage), userInfo: nil, repeats: true)
        timer.fire()
        
        
        dreamTextView.isEditable = false
        dreamTextView.backgroundColor = UIColor.clear
        nextButton.isEnabled = false
        animateStartButton()
        
        // Do any additional setup after loading the view.
        
        FirebaseDatabaseManager().getArcitleArray(vc: self)
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
    
    func animateStartButton() {
        UIView.animate(withDuration: 1.0, animations: {
            
            self.dreamImageView.frame.origin.y -= 5
            self.dreamImageView.frame.size = CGSize(width: 380, height: 320)
            self.dreamImageView.center.x = self.view.center.x
            self.dreamImageView.alpha = 0.98
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.dreamImageView.frame.origin.y += 5
                self.dreamImageView.frame.size = CGSize(width: 360, height: 300)
                self.dreamImageView.center.x = self.view.center.x
                self.dreamImageView.alpha = 0.90
            }, completion: { _ in
                self.animateStartButton()
            })
        })
    }
    
    
    @IBAction func onTappedHome(_ sender: UIButton) {
        gobackToHome()
    }
    
    
    
    @IBAction func onTappedNext(_ sender: UIButton) {
        // 前のviewを上に飛ばす
        let preDreamImageView = UIImageView(frame: dreamImageView.frame)
        preDreamImageView.contentMode = .scaleAspectFit
        preDreamImageView.image = dreamImageView.image
        let preDreamTextView = UITextView(frame: dreamTextView.frame)
        preDreamTextView.backgroundColor = UIColor.clear
        preDreamTextView.text = dreamTextView.text
        self.view.addSubview(preDreamImageView)
        self.view.addSubview(preDreamTextView)
        UIView.animate(withDuration: 2.0, animations: {
            preDreamImageView.center.y -= 600
            preDreamImageView.alpha = 0.3
            preDreamTextView.center.y -= 600
        }, completion: { _ in
            preDreamImageView.removeFromSuperview()
            preDreamTextView.removeFromSuperview()
        })
        
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
        
        dreamTextView.alpha = 0.2
        dreamImageView.alpha = 0.2
        self.dreamImageView.frame.size = CGSize(width: 180, height: 150)
        self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 330)
        UIView.animate(withDuration: 1.0, animations: {
            self.dreamTextView.alpha = 1.0
            self.dreamImageView.alpha = 1.0
            self.dreamImageView.frame.size = CGSize(width: 360, height: 300)
            self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 330)
        }, completion: { _ in
            self.nextButton.isEnabled = true
        })
    }
    
    func stopDisplay() {
        dreamTextView.text = ""
        sorryImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: 150, height: 120))
        sorryImageView.center = CGPoint(x: self.view.frame.width / 2,
                                        y: dreamTextView.center.y - 100)
        sorryImageView.contentMode = .scaleAspectFit
        self.view.addSubview(sorryImageView)
        
        timerSorry = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(ReadViewController.updateSorryImage), userInfo: nil, repeats: true)
        timerSorry.fire()
        
        let sorryMessageImageView = UIImageView(frame: dreamTextView.frame)
        sorryMessageImageView.contentMode = .scaleAspectFit
        sorryMessageImageView.image = UIImage(named: "serif_sorry.png")
        self.view.addSubview(sorryMessageImageView)
        
        nextButton.isEnabled = false
        
        // アニメーション
        dreamTextView.alpha = 0.2
        dreamImageView.alpha = 0.2
        sorryImageView.alpha = 0.2
        self.dreamImageView.frame.size = CGSize(width: 180, height: 150)
        self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 330)
        self.sorryImageView.frame.size = CGSize(width: 100, height: 80)
        self.sorryImageView.center = CGPoint(x: self.view.frame.width / 2,
                                        y: dreamTextView.center.y - 100)
        UIView.animate(withDuration: 1.5, animations: {
            self.dreamTextView.alpha = 1.0
            self.dreamImageView.alpha = 1.0
            self.dreamImageView.frame.size = CGSize(width: 360, height: 300)
            self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 330)
            self.sorryImageView.frame.size = CGSize(width: 150, height: 120)
            self.sorryImageView.center = CGPoint(x: self.view.frame.width / 2,
                                                 y: self.dreamTextView.center.y - 100)
            
        }, completion: { _ in
            self.nextButton.isEnabled = true
        })
        
        
    }
    
    @objc func updateSorryImage() {
        sorryImageIndex += 1
        if sorryImageIndex >= 2 {
            sorryImageIndex = 0
        }
        sorryImageView.image = sorryImageArray[sorryImageIndex]
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
        
        UIView.animate(withDuration: 3.0, animations: {
            self.bgImageView.alpha = 0.0
        }, completion: { _ in
            self.timer.invalidate()
            self.bgImageView.removeFromSuperview()
        })
    }
    
    
    func failedSetLooked(message: String) {
        print(message)
    }
    
    func successSetLooked() {
        
    }
}

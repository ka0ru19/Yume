//
//  StartViewController.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView! // アニメーションさせる
    @IBOutlet weak var topImageView: UIImageView!
    
    var startButtonSizeRate: CGFloat = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        animateStartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateStartButton() {
        UIView.animate(withDuration: 1.0, animations: {
            self.topImageView.frame.origin.y -= 5
            self.startImageView.frame.size = CGSize(width: 50 * self.startButtonSizeRate, height: 50 * self.startButtonSizeRate)
            self.startImageView.center = CGPoint(x: self.view.frame.width / 2, y: 450)
            self.startImageView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.topImageView.frame.origin.y += 5
                self.startImageView.frame.size = CGSize(width: 65 * self.startButtonSizeRate, height: 65 * self.startButtonSizeRate)
                self.startImageView.center = CGPoint(x: self.view.frame.width / 2, y: 450)
                self.startImageView.alpha = 0.7
            }, completion: { _ in
                self.animateStartButton()
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInputVC" {
            print("InputVCに遷移")
        } else if segue.identifier == "toArchiveVC" {
            print("ArchiveVCに遷移")
        }
    }
    
    @IBAction func onTappedStart(_ sender: UIButton) {
        FirebaseAuthManager().signInAnonymously(vc: self)
    }
    
    
    @IBAction func onTappedArchive(_ sender: UIButton) {
        // 直近の自分の投稿を取得できたら画面遷移
        performSegue(withIdentifier: "toArchiveVC", sender: nil)
    }
}

// MARK: - Firebaseからのレスポンス
extension StartViewController {
    func failedSignInAnonymously(message: String) {
        print(message)
    }
    func successSignInAnonymously() {
            performSegue(withIdentifier: "toInputVC", sender: nil)
    }
}

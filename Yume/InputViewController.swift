//
//  InputViewController.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    @IBOutlet weak var dreamImageView: UIImageView!
    @IBOutlet weak var dreamTextView: UITextView!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dreamTextView.becomeFirstResponder()
        dreamTextView.backgroundColor = UIColor.clear
        animateStartButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReadVC" {
            print("ReadVCに遷移")
        }
    }
    
    func animateStartButton() {
        UIView.animate(withDuration: 1.0, animations: {
            self.dreamImageView.frame.size = CGSize(width: 390, height: 350)
            self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 200)
            self.dreamImageView.alpha = 0.98
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.dreamImageView.frame.size = CGSize(width: 400, height: 360)
                self.dreamImageView.center = CGPoint(x: self.view.frame.width / 2, y: 200)
                self.dreamImageView.alpha = 0.90
            }, completion: { _ in
                self.animateStartButton()
            })
        })
    }
    
    @IBAction func onTappedPost(_ sender: UIButton) {
        guard let text = dreamTextView.text else {return}
        if text.characters.count == 0 { return }
        
        let postDict: [String: String] = [
            "text": text,
            "date": Date().string(),
            ]
        FirebaseDatabaseManager().postNewArcitle(newValue: postDict, vc: self)
    }
    
    @IBAction func onTappedCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension InputViewController {
    func failedGetArcitleArray(message: String) {
        print(message)
    }
    func successPostNewArcitle() {
        performSegue(withIdentifier: "toReadVC", sender: nil)
    }
}



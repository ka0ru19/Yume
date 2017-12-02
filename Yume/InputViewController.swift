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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dreamTextView.becomeFirstResponder()

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



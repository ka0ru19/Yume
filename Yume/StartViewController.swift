//
//  StartViewController.swift
//  Yume
//
//  Created by Wataru Inoue on 2017/12/02.
//  Copyright © 2017年 Wataru Inoue. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInputVC" {
            print("InputVCに遷移")
        }
    }
    
    @IBAction func onTappedStart(_ sender: UIButton) {
        FirebaseAuthManager().signInAnonymously(vc: self)
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

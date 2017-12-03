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

        FirebaseDatabaseManager().getRecentPost(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ArchiveViewController {
    func faildLoadRecentPost() {
        
    }
    
    func successLoadRecentPost(dict: Dictionary<String, AnyObject>) {
        print("successLoadRecentPost")
        print(dict)
    }
}

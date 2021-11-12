//
//  WalkthroughViewController.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/10.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var walkthroughView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black
            .withAlphaComponent(0.5)
        
        walkthroughView.backgroundColor = .systemGray6
        walkthroughView.layer.cornerRadius = 20
        walkthroughView.clipsToBounds = true
    }
    
    @IBAction func walkthroughButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

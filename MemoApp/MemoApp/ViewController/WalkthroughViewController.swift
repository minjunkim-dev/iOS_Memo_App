//
//  WalkthroughViewController.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/10.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var walkthroughView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black
            .withAlphaComponent(0.5)
        
        walkthroughView.backgroundColor = .systemGray6
        walkthroughView.layer.cornerRadius = 20
        walkthroughView.clipsToBounds = true
        
        confirmButton.backgroundColor = .systemYellow
        confirmButton.layer.cornerRadius = 10
        confirmButton.clipsToBounds = true
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func walkthroughButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

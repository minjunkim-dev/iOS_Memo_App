//
//  WriteEditViewController.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/08.
//

import UIKit

import RealmSwift

class WriteEditViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let localRealm = try! Realm()
    
    var writeButtonActionHandler: (() -> Void)?
    var selectCellActionHandler: (() -> Void)?
    var backButtonActionHandler: (() -> Void)?
    
    var shareButton: UIBarButtonItem!
    var compeletionButton: UIBarButtonItem!
    
    var memo: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.delegate = self
        textView.text = memo?.memoText
        
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.navigationBar.barTintColor = .systemGray6
        
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        compeletionButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(completionButtonClicked))
        
        writeButtonActionHandler?()
        selectCellActionHandler?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            backButtonActionHandler?()
            textView.text = nil
        }
    }
    
    @objc func completionButtonClicked() {
        print(#function)
                
        navigationItem.rightBarButtonItems
         = [shareButton]
        
        view.endEditing(true)
    }
    
    func writeMemo() {
        
        memo?.memoText = textView.text
        let text = textView.text.components(separatedBy: CharacterSet.newlines)
        
        let result = text.filter { !($0.trimmingCharacters(in: .whitespaces).isEmpty) }
        
        guard let title = result.first else {
            memo?.memoTitle = "New Note"
            return
        }
        memo?.memoTitle = title
        
        if let content = result.last, title != content {
            memo?.memoContent = content
        } else {
            memo?.memoContent = "New additional text"
        }
        
        guard let row = memo else { return }
        
        try! self.localRealm.write {
            print("메모 쓰는중")
            localRealm.add(row)
        }
        
    }
    
    func editMemo() {
    
        
        let text = textView.text.components(separatedBy: CharacterSet.newlines)
        
        let result = text.filter { !($0.trimmingCharacters(in: .whitespaces).isEmpty) }
        
        try! localRealm.write {
            memo?.memoText = textView.text
            print("메모 수정중")
            guard let title = result.first else {
                memo?.memoTitle = "New Note"
                return
                
            }
            memo?.memoTitle = title
            
            if let content = result.last, title != content {
                memo?.memoContent = content
            } else {
                memo?.memoContent = "New additional text"
            }
        }
    }
    
    @objc func shareButtonClicked() {
        presentActivityViewController()
    }
        
    func presentActivityViewController() {
        
        let shareText: String = "share text test!" // dummy
        var shareObject = [Any]()
        shareObject.append(shareText)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: [])
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension WriteEditViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItems
         = [compeletionButton, shareButton]
    }
}

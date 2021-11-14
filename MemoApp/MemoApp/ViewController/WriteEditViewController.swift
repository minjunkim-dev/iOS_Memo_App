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
    var backButtonActionHandler: (() -> Void)?
    
    var shareButton: UIBarButtonItem!
    var compeletionButton: UIBarButtonItem!
    
    var memo: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.delegate = self
        textView.text = memo?.memoText
        
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        compeletionButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(completionButtonClicked))
        
        navigationItem.rightBarButtonItems
         = [shareButton]
        
        writeButtonActionHandler?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            backButtonActionHandler?()
            textView.text = nil
        }
    }
    
    @objc func completionButtonClicked() {
                
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
            memo?.memoContent = "No additional text"
        }
        
        guard let row = memo else { return }
        
        try! self.localRealm.write {
            localRealm.add(row)
        }
    }
    
    func editMemo() {
    
        let text = textView.text.components(separatedBy: CharacterSet.newlines)
        
        let result = text.filter { !($0.trimmingCharacters(in: .whitespaces).isEmpty) }
        
        try! localRealm.write {
            memo?.memoText = textView.text
            guard let title = result.first else {
                memo?.memoTitle = "New Note"
                return
                
            }
            
            let previousTitle = memo?.memoTitle
            memo?.memoTitle = title
            
            
            let previousContent = memo?.memoContent
            if let content = result.last, title != content {
                memo?.memoContent = content
            } else {
                memo?.memoContent = "No additional text"
            }
            
            
            // 메모가 수정된 경우, 해당 시간으로 갱신 필요
            if previousTitle != memo?.memoTitle || previousContent != memo?.memoContent {
                memo?.memoDate = Date()
                let time = DateFormatter.date2String(date: memo!.memoDate)
                memo?.memoTime = time
            }
        }
    }
    
    @objc func shareButtonClicked() {
        
        completionButtonClicked()
        editMemo()
        
        presentActivityViewController()
    }
        
    func presentActivityViewController() {
        
        /* Memo 구조체 자체를 저장할 순 없을까? */
        guard let shareMemo = memo?.memoText else { return }
        var shareObject = [Any]()
        shareObject.append(shareMemo)
        
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

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
    
    var writeButtonActionHandler: (() -> ())?
    var selectCellActionHandler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.navigationBar.barTintColor = .systemGray6
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        let compeletionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        
        navigationItem.rightBarButtonItems
         = [compeletionButton, shareButton]
        
        writeButtonActionHandler?()
        selectCellActionHandler?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            backButtonClicked()
        }
    }
    
    @objc func completionButtonClicked() {
    
        /* 메모 저장 필요 */
        saveMemo()
    }
    
    func saveMemo() {
        
        if let text = textView.text?.components(separatedBy: CharacterSet.newlines) {
            
            let date = Date()
            let time = date2TimeString(date: date)
            let title = text.first
            let content = text.last
            let pinned = false
            
            let row = Memo(date: date, time: time, title: title, content: content, pinned: pinned)
            try! self.localRealm.write {
                localRealm.add(row)
            }
            
            textView.text = nil
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func date2TimeString(date: Date) -> String {
     
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd a HH:mm"
        
        return dateFormatter.string(for: date) ?? ""
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
    
    @objc func backButtonClicked() {
        
        /* 메모 저장 필요 */
        saveMemo()
    }
}

//
//  Alert+Extension.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/14.
//

import Foundation
import SwiftUI

extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            okAction()
        }
        let cancel = UIAlertAction(title: "Cancle", style: .destructive)
        
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
    
        self.present(alert, animated: true) {
            // alert을 보여준 이후에 하고 싶은 것을 작성
            print("alert이 떴습니다.")
        }
    }
}

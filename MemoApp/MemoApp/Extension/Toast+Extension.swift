//
//  Toast+Extension.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/14.
//

import Foundation

import Toast

extension ToastManager {
    
    static var customToast: ToastStyle {
     
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.backgroundColor = .systemGray3
        style.messageColor = .white
        style.messageFont = .systemFont(ofSize: 15, weight: .semibold)

        return style
    }
}

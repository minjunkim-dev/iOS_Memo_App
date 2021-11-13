//
//  Memo.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/08.
//

import Foundation

import RealmSwift

// Memo: table name
// @Persisted: column
class Memo: Object {
    @Persisted var memoDate: Date // 최근순 정렬에 이용(UTC 기준)
    @Persisted var memoTime: String // local 기준
    @Persisted var memoText: String? // 전체 텍스트
    @Persisted var memoTitle: String?
    @Persisted var memoContent: String?
    @Persisted var memoPinned: Bool
    
    // PK(필수)
    // PK 이름은 _로 시작하는 것을 권장
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(date: Date, time: String, text: String? = nil, title: String? = "New Note", content: String? = "New additional text", pinned: Bool = false) {
        self.init()
        
        self.memoDate = date
        self.memoTime = time
        self.memoText = text
        self.memoTitle = title
        self.memoContent = content
        self.memoPinned = pinned
    }
}

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
    @Persisted var memoDate: Date // 최근순 정렬에 이용
    @Persisted var memoTime: String
    @Persisted var memoTitle: String?
    @Persisted var memoContent: String?
    @Persisted var memoPinned: Bool
    
    // PK(필수)
    // PK 이름은 _로 시작하는 것을 권장
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(date: Date, time: String, title: String?, content: String?, pinned: Bool) {
        self.init()
        
        self.memoDate = date
        self.memoTime = time
        self.memoTitle = title
        self.memoContent = content
        self.memoPinned = pinned
    }
}

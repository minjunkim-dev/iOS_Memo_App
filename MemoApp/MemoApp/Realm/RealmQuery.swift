
import UIKit

import RealmSwift

extension UIViewController {
    
    func searchQueryFromMemo(text: String) -> Results<Memo> {
        let localRealm = try! Realm()

        let search = localRealm.objects(Memo.self).filter("memoTitle CONTAINS[c] '\(text)' OR memoContent CONTAINS[c] '\(text)'").sorted(byKeyPath: "memoDate", ascending: false)
        return search
    }
    
    func getAllMemo() -> Results<Memo> {
        let localRealm = try! Realm()
        
        return localRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func getMemo(pinned: Bool) -> Results<Memo> {
        let localRealm = try! Realm()
        
        return localRealm.objects(Memo.self).filter("memoPinned == \(pinned)").sorted(byKeyPath: "memoDate", ascending: false)
    }
}

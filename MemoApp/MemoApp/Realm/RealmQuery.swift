
import UIKit

import RealmSwift

extension UIViewController {
    
    func searchQueryFromMemo(text: String) -> Results<Memo> {
        let localRealm = try! Realm()

        let search = localRealm.objects(Memo.self).filter("memoTitle CONTAINS[c] '\(text)' OR memoContent CONTAINS[c] '\(text)'")
        return search
    }
    
    func getAllMemo() -> Results<Memo> {
        let localRealm = try! Realm()
        
        return localRealm.objects(Memo.self)
    }
    
    func getMemo(pinned: Bool) -> Results<Memo> {
        let localRealm = try! Realm()
        
        return localRealm.objects(Memo.self).filter("memoPinned == \(pinned)")
    }
}

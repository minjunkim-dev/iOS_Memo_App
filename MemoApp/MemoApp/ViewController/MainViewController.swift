

import UIKit

import RealmSwift



class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let localRealm = try! Realm()

    var unpinnedMemo: Results<Memo>!
    var pinnedMemo: Results<Memo>!
    
    func date2TimeString(date: Date) -> String? {
     
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd a HH:mm"
        
        return dateFormatter.string(for: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        print("Realm is located at:", localRealm.configuration.fileURL!)

        
        unpinnedMemo = getMemo(pinned: false)
        pinnedMemo = getMemo(pinned: true)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memoCount = numberFormatter.string(for: getAllMemoCount()) ?? "0"
        self.navigationItem.title = "\(memoCount)개의 메모"
        self.navigationItem.largeTitleDisplayMode = .always

        self.navigationController?.isToolbarHidden = false
        
        if !isAppAlreadyLaunchedOnce() {
            
            let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        
            guard let vc = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController else { return }
        
            vc.modalPresentationStyle = .overCurrentContext
        
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func writeButtonClicked(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "WriteEdit", bundle: nil)
    
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WriteEditViewController") as? WriteEditViewController else { return }
        
        vc.writeButtonActionHandler = {
            print("writeButtonActionHandler")
            self.navigationItem.backButtonTitle = "메모"
            vc.textView.becomeFirstResponder()
        }
    
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if pinnedMemo.isEmpty {
            return "메모"
        } else {
            return section == 0 ? "고정된 메모" : "메모"
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return pinnedMemo.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pinnedMemo.isEmpty {
            return unpinnedMemo.count
        } else {
            return section == 0 ? pinnedMemo.count : unpinnedMemo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        var row: Memo
        if pinnedMemo.isEmpty {
            row = unpinnedMemo[indexPath.row]
            
        } else {
            if indexPath.section == 0 {
                row = pinnedMemo[indexPath.row]
            } else {
                row = unpinnedMemo[indexPath.row]
            }
        }
        
        /* configure tableview cell */
        cell.configureCell(row: row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pin = UIContextualAction(style: .normal, title: nil
                                     , handler: { action, view, completion in
                            
//                var row: Memo
//
//                if self.pinnedMemo.isEmpty {
//                    row = self.unpinnedMemo[indexPath.row]
//                } else {
//                    if indexPath.row == 0 { // pinned
//                        row = self.pinnedMemo[indexPath.row]
//                    } else { // unpinned
//                        row = self.unpinnedMemo[indexPath.row]
//                    }
//                }
//
//                try! self.localRealm.write {
//                    self.localRealm.delete(row)
//                }
//
//                row.memoPinned = !(row.memoPinned)
//
//                try! self.localRealm.write {
//                    self.localRealm.add(row)
//                    tableView.reloadData()
//                }
//
                print("pinned performed")
                completion(true)
            })
        
        pin.image = UIImage(systemName: "pin.fill")
        pin.image?.withTintColor(.white)
        pin.backgroundColor = .systemOrange
            
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil, handler: { action, view, completion in
            
//                var row: Memo
//                if self.pinnedMemo.isEmpty {
//                    row = self.unpinnedMemo[indexPath.row]
//                } else {
//                    if indexPath.row == 0 { // pinned
//                        row = self.pinnedMemo[indexPath.row]
//                    } else { // unpinned
//                        row = self.unpinnedMemo[indexPath.row]
//                    }
//                }
//
//                try! self.localRealm.write {
//                    self.localRealm.delete(row)
//                    tableView.reloadData()
//                }

                print("delete performed")
                completion(true)
           })
     
        delete.image = UIImage(systemName: "trash.fill")
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .white
        header?.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UIScreen.main.bounds.height / 13
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        
        let storyboard = UIStoryboard(name: "WriteEdit", bundle: nil)
    
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WriteEditViewController") as? WriteEditViewController else { return }
        
        vc.selectCellActionHandler = {
            print("selectCellActionHandler")
            self.navigationItem.backButtonTitle = "검색"
        }
    
        navigationController?.pushViewController(vc, animated: true)
      
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)

        guard let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        
        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}


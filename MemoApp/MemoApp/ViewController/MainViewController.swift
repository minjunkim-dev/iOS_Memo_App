

import UIKit

import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var writeButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIBarButtonItem!
    
    let localRealm = try! Realm()

    var unpinnedMemo: Results<Memo>!
    var pinnedMemo: Results<Memo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
        navigationItem.largeTitleDisplayMode = .always
        writeButton.tintColor = .systemYellow
        
        
        if !isAppAlreadyLaunchedOnce() {
            
            let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        
            guard let vc = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController else { return }
        
            vc.modalPresentationStyle = .overCurrentContext
        
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData() {
        print(#function)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        unpinnedMemo = getMemo(pinned: false)
        pinnedMemo = getMemo(pinned: true)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memoCount = numberFormatter.string(for: getAllMemo().count) ?? "0"
        navigationItem.title = "\(memoCount) Notes"
        
        tableView.reloadData()
    }
    
    @IBAction func writeButtonClicked(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "WriteEdit", bundle: nil)
    
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WriteEditViewController") as? WriteEditViewController else { return }
        
        navigationItem.backButtonTitle = "Memo"
        vc.writeButtonActionHandler = {
            vc.textView.becomeFirstResponder()
        }
        
        vc.backButtonActionHandler = {
            vc.writeMemo()
            vc.navigationController?.popViewController(animated: true)
        }
    
        let date = Date()
        let time = DateFormatter.date2String(date: date)
        let memo = Memo(date: date, time: time)
        vc.memo = memo
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
        
        if !(pinnedMemo.isEmpty) {
            return section == 0 ? "Pinned" : "Notes"
        } else {
            return nil
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
            indexPath.section == 0 ? (row = pinnedMemo[indexPath.row]) : (row = unpinnedMemo[indexPath.row])
        }
        
        /* configure tableview cell */
        cell.configureCell(row: row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var row: Memo
        if self.pinnedMemo.isEmpty {
            row = self.unpinnedMemo[indexPath.row]
        } else {
            indexPath.section == 0 ? (row = self.pinnedMemo[indexPath.row]) : (row = self.unpinnedMemo[indexPath.row])
        }
        
        let pin = UIContextualAction(style: .normal, title: nil
                                     , handler: { action, view, completion in
                
                try! self.localRealm.write {
                    row.memoPinned = !row.memoPinned
                    self.reloadData()
                }
            
                print("pinned or unpinned performed")
                completion(true)
            })
        
        row.memoPinned ? (pin.image = UIImage(systemName: "pin.slash.fill")) : (pin.image = UIImage(systemName: "pin.fill"))
        pin.image?.withTintColor(.white)
        pin.backgroundColor = .systemOrange
            
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        var row: Memo
        if self.pinnedMemo.isEmpty {
            row = self.unpinnedMemo[indexPath.row]
        } else {
            indexPath.section == 0 ? (row = self.pinnedMemo[indexPath.row]) : (row = self.unpinnedMemo[indexPath.row])
        }
        
        let delete = UIContextualAction(style: .normal, title: nil, handler: { action, view, completion in
            
                try! self.localRealm.write {
                    self.localRealm.delete(row)
                    self.reloadData()
                }

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
        
        return pinnedMemo.isEmpty ? 0 : UIScreen.main.bounds.height / 13
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "WriteEdit", bundle: nil)
    
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WriteEditViewController") as? WriteEditViewController else { return }
        
        navigationItem.backButtonTitle = "Memo"
     
        vc.backButtonActionHandler = {
            vc.editMemo()
            vc.navigationController?.popViewController(animated: true)
        }
    
        var row: Memo
        if pinnedMemo.isEmpty {
            row = unpinnedMemo[indexPath.row]
        } else {
            indexPath.section == 0 ? (row = pinnedMemo[indexPath.row]) : (row = unpinnedMemo[indexPath.row])
        }
        
        let date = row.memoDate
        let time = row.memoTime
        
        try! localRealm.write {
            row.memoDate = date
            row.memoTime = time
            vc.memo = row
        }
        
        navigationController?.pushViewController(vc, animated: true)
      
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
        let storyboard = UIStoryboard(name: "Search", bundle: nil)

        guard let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }

        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        present(nav, animated: true, completion: nil)
    }
}


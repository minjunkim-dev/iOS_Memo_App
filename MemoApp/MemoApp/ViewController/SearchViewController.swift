//
//  SearchViewController.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/08.
//

import UIKit

import RealmSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let localRealm = try! Realm()

    var searchMemo: Results<Memo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.tintColor = .systemYellow
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
        searchBar.keyboardType = .default
        
        searchBar.setValue("Cancle", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
        
        searchMemo = searchQueryFromMemo(text: searchBar.text ?? "")
        
        
    }
    
    func reloadData() {
        print("Realm is located at:", self.localRealm.configuration.fileURL!)
        searchMemo = searchQueryFromMemo(text: searchBar.text ?? "")

        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memoCount = numberFormatter.string(for: searchMemo.count) ?? "0"
        
        return "\(memoCount) Found"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return searchMemo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        var row: Memo
        row = searchMemo[indexPath.row]
        
        /* configure tableview cell */
        cell.configureCell(row: row, searchText: searchBar.text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .white
        header?.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let row = searchMemo[indexPath.row]
        
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
      
        let row = searchMemo[indexPath.row]
        
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

        return UIScreen.main.bounds.height / 13

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        
        let storyboard = UIStoryboard(name: "WriteEdit", bundle: nil)
    
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WriteEditViewController") as? WriteEditViewController else { return }
        
        navigationItem.backButtonTitle = "Search"
                
        vc.backButtonActionHandler = {
            vc.editMemo()
            vc.navigationController?.popViewController(animated: true)
            tableView.reloadData()
        }
    
        let row = searchMemo[indexPath.row]
        
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

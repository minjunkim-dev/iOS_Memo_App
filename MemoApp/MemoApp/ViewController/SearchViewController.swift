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
    var searchMemoCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchMemo = searchQueryFromMemo(text: searchBar.text ?? "")
        searchMemoCount = searchMemo.count
    }
    
    @IBAction func cancleButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return "\(searchMemoCount)개 찾음"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return searchMemoCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        var row: Memo
        row = searchMemo[indexPath.row]
        
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
                print("pin performed")
                completion(true)
            })
        
        pin.image = UIImage(systemName: "pin.fill")
        pin.image?.withTintColor(.white)
        pin.backgroundColor = .systemOrange
            
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    
//    수정, 삭제 기능을 실제로 추가하여야 함
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil, handler: { action, view, completion in
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
    
    // 메모 수정
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)

        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        
        /*
         실시간으로 현재 저장된 "전체 메모" 중에서
         (제목 or 내용) 중 검색 텍스트를 "포함"한 메모들을 검색하여 찾아내고,
         이를 searchedMemos에 저장한 후, reloadData()!!!
         */
    }
}

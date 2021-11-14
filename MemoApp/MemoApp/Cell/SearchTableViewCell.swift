//
//  SearchTableViewCell.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/10.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoTimeLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(row: Memo, searchText: String?) {
     
        self.contentView.layer.cornerRadius = 10
        self.backgroundColor = .systemGray6
        
        /* 검색한 키워드에 해당하는 단어는
         텍스트 컬러를 변경해주어야 함!!!
         */
        
        
        
        

        memoTitleLabel.text = row.memoTitle
        memoTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        memoTitleLabel.textColor = .white
        
        let titleRange = (memoTitleLabel.text! as NSString).range(of: searchText ?? "")
        let mutableAttributedStringTitle = NSMutableAttributedString.init(string: memoTitleLabel.text!)
        mutableAttributedStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: titleRange)
        memoTitleLabel.attributedText = mutableAttributedStringTitle
        

        //        memoTimeLabel.text = row.memoTime
        let time = DateFormatter.date2String(date: row.memoDate)
        memoTimeLabel.text = time
        memoTimeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        memoTimeLabel.textColor = .systemGray
        
        memoContentLabel.text = row.memoContent
        memoContentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        memoContentLabel.textColor = .systemGray
        
        let contentRange = (memoContentLabel.text! as NSString).range(of: searchText ?? "")
        let mutableAttributedStringContent = NSMutableAttributedString.init(string: memoTitleLabel.text!)
        mutableAttributedStringContent.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: contentRange)
        memoContentLabel.attributedText = mutableAttributedStringContent
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

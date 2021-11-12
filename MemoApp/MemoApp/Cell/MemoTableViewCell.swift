//
//  MemoTableViewCell.swift
//  MemoApp
//
//  Created by bene9275 on 2021/11/08.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    static let identifier = "MemoTableViewCell"
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoTimeLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func configureCell(row: Memo) {
     
        self.contentView.layer.cornerRadius = 10
        self.backgroundColor = .systemGray6
        
        memoTitleLabel.text = row.memoTitle
        memoTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        memoTitleLabel.textColor = .white
        
        memoTimeLabel.text = row.memoTime
        memoTimeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        memoTimeLabel.textColor = .systemGray
        
        memoContentLabel.text = row.memoContent
        memoContentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        memoContentLabel.textColor = .systemGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

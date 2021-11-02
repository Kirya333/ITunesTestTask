//
//  TrackCell.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

}

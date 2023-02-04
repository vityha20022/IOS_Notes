//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Виктор Борисовский on 04.02.2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteHeaderTextField: UITextField!
    @IBOutlet weak var noteBodyTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

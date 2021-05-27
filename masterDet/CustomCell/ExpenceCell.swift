//
//  ExpenceCell.swift
//  masterDet
//
 //  Created by user192220 on 5/17/21.
//

import UIKit

class ExpenceCell: UITableViewCell {

//    @IBOutlet weak var labelExpencename: UILabel!
//    @IBOutlet weak var labelExpenceValue: UILabel!
//    @IBOutlet weak var labelNotes: UILabel!
//    @IBOutlet weak var labelDueDate: UILabel!
    
    @IBOutlet weak var labelExpenceName: UILabel!
    
    @IBOutlet weak var labelExpenceAmount: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var LableDueDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

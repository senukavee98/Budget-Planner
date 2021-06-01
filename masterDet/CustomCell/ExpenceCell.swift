//
//  ExpenceCell.swift
//  masterDet
//
 //  Created by user192220 on 5/17/23.
//

import UIKit

class ExpenceCell: UITableViewCell {

//    @IBOutlet weak var labelExpencename: UILabel!
//    @IBOutlet weak var labelExpenceValue: UILabel!
//    @IBOutlet weak var labelNotes: UILabel!
//    @IBOutlet weak var labelDueDate: UILabel!
    
    let progressView = CustomProgressView(progressViewStyle: .bar)
    
    @IBOutlet weak var labelExpenceName: UILabel!
    
    @IBOutlet weak var labelExpenceAmount: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var LableDueDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        progressBar.progress = 0.2
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.tintColor = ColorConverter().hexStringToUIColor(hex: "E8E4E3")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleProgressValue(value: Double) {
        if labelExpenceName.text != nil {
            progressBar.progress = 0.2
    }
}
}

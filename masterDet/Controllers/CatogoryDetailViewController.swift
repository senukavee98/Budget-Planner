//
//  CatogoryDetailViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/22.
//

import UIKit

class CatogoryDetailViewController: UIViewController {
    
    let pieChart = PieChartView()
    
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelTotalBudget: UILabel!
    @IBOutlet weak var labelRemaining: UILabel!
    @IBOutlet weak var labelSpent: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    
    var categoryName = "Category"
    var totalBudget = 0.0
    var remainingAmount = 0.0
    var spentAmount = 1.0
    var note = "NOTES"
    var expence_data_array: NSMutableArray = []
    var budget: Budget?
    var expName: String? {
        didSet {
            print("Value changed!!!!!")
        }
    }
    var expValue: Double?
    var expences:Expence?
    
    init(name: String, amount: Double) {
        self.expName = name
        self.expValue = amount
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        labelCategoryName.text = categoryName.uppercased()
        labelTotalBudget.text = String(totalBudget)
        labelNotes.text = "NOTE: " + note
        labelRemaining.text = String(remainingAmount)

        let padding: CGFloat = 20
        let height = (view.frame.height - padding * 3) / 2
        
        let color = ColorConverter()
        let one = color.hexStringToUIColor(hex: "ef9a9a")
        let two = color.hexStringToUIColor(hex: "ce93d8")
        let three = color.hexStringToUIColor(hex: "80deea")
        let four = color.hexStringToUIColor(hex: "aed581")
        let five = color.hexStringToUIColor(hex: "ffd54f")
        let six = color.hexStringToUIColor(hex: "ff8a65")
        let seven = color.hexStringToUIColor(hex: "90a4ae")
        let eight = color.hexStringToUIColor(hex: "ff8a65")
        
        pieChart.frame = CGRect(
            x: 0, y: padding, width: view.frame.size.width, height: 350
        )
        
        pieChart.segments = [
            LabelledSegment(color: one, name: "Red",        value: 57.56),
            LabelledSegment(color: #colorLiteral(red: 1.0, green: 0.541176471, blue: 0.0, alpha: 1.0), name: "Orange",     value: 30),
            LabelledSegment(color: #colorLiteral(red: 0.478431373, green: 0.423529412, blue: 1.0, alpha: 1.0), name: "Purple",     value: 27),
            LabelledSegment(color: #colorLiteral(red: 0.0, green: 0.870588235, blue: 1.0, alpha: 1.0), name: "Light Blue", value: 40),
            LabelledSegment(color: #colorLiteral(red: 0.392156863, green: 0.945098039, blue: 0.717647059, alpha: 1.0), name: "Green",      value: 25),
            LabelledSegment(color: #colorLiteral(red: 0.0, green: 0.392156863, blue: 1.0, alpha: 1.0), name: "Blue",       value: 38)
        ]
        
        pieChart.segmentLabelFont = .systemFont(ofSize: 15)
        
        view.addSubview(pieChart)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddCategoryViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/21.
//

import UIKit

enum pickedColor: Int {
    case blue, pink, purple, green, orange
}

class AddCategoryViewController: UIViewController {
    var selectedColor = "FFFFFF"
    @IBOutlet weak var textFieldBudgetAmount: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var textFireldCategoryName: UITextField!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCellColorChange(_ sender: UIButton) {
        switch pickedColor(rawValue: sender.tag) {
        case .blue:
            selectedColor = "B2E6F2"
        case .pink:
            selectedColor = "E3C5D3"
            print("PINK")
        case .purple:
            selectedColor = "B2C5F2"
        case .green:
            selectedColor = "E3EFD3"
        case .orange:
            selectedColor = "F7C9A3"
        case .none:
            print("NOTHING")
        }
    }
    
    @IBAction func handleSave(_ sender: UIButton) {
    let newBudget = Budget(context: context)
    
        if self.textFireldCategoryName.text != "" {
            newBudget.category_name = self.textFireldCategoryName.text
            newBudget.amount = Double(self.textFieldBudgetAmount.text!) ?? 0.0
            newBudget.notes = self.textViewNotes.text
            newBudget.color = self.selectedColor
            
            //save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            //inser an alert if catogoary name not entered
        }
        
        
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

//
//  AddCategoryViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/21.
//

import UIKit
import CoreData

enum pickedColor: Int {
    case blue, pink, purple, green, orange
}

class AddCategoryViewController: UIViewController {
    var selectedColor = "FFFFFF"
    var boarderColor = "b0bec5"
    var isEditingData: Bool = false
    @IBOutlet weak var textFieldBudgetAmount: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var textFireldCategoryName: UITextField!
    
    var editingCategory: Budget? {
        didSet {
            // Update the view.
            isEditingData = true
//            configureView()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingData {
            textFireldCategoryName.text = editingCategory?.category_name
            textViewNotes.text = editingCategory?.notes
            textFieldBudgetAmount.text = String(editingCategory!.amount)
        }


        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCellColorChange(_ sender: UIButton) {
        switch pickedColor(rawValue: sender.tag) {
        case .blue:
            selectedColor = "B2E6F2"
            boarderColor = "5ddef4"
        case .pink:
            selectedColor = "E3C5D3"
            boarderColor = "ffa4a2"
        case .purple:
            selectedColor = "B2C5F2"
            boarderColor = "ba68c8"
        case .green:
            selectedColor = "E3EFD3"
            boarderColor = "81c784"
        case .orange:
            selectedColor = "F7C9A3"
            boarderColor = "ff8a65"
        case .none:
            selectedColor = "bcaaa4"
            boarderColor = "90a4ae"
        }
    }
    
    @IBAction func handleSave(_ sender: UIButton) {
        let entity = NSEntityDescription.entity(forEntityName: "Budget", in: context)!
        var category = NSManagedObject()

        if isEditingData {
            category = (editingCategory! as Budget)
            category.setValue(self.textFireldCategoryName.text, forKey: "category_name")
            category.setValue(Double(self.textFieldBudgetAmount.text!) ?? 0.0, forKey: "amount")
            category.setValue(self.textViewNotes.text, forKey: "notes")
            category.setValue(self.selectedColor, forKey: "color")
            category.setValue(self.boarderColor, forKey: "boarderColor")

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            
            if self.textFieldBudgetAmount.text!.isNumeric {
                if self.textFireldCategoryName.text != "" {
    //                let newBudget = Budget(context: context)
                    category = NSManagedObject(entity: entity, insertInto: context)
                    category.setValue(self.textFireldCategoryName.text, forKey: "category_name")
                    category.setValue(Double(self.textFieldBudgetAmount.text!) ?? 0.0, forKey: "amount")
                    category.setValue(self.textViewNotes.text, forKey: "notes")
                    category.setValue(self.selectedColor, forKey: "color")
                    category.setValue(self.boarderColor, forKey: "boarderColor")
        //            //save
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                } else {
                    //inser an alert if catogoary name not entered
                    let alert = UIAlertController(title: "Warning !", message: "Please Enter a Category before saving", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Warning !", message: "Please Enter a valid input for Expense amount", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }



    func configureView() {
        if isEditingData {
            self.navigationItem.title = "Edit Project"
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
        
        if let category = editingCategory {
            if let categoryName = textFireldCategoryName {
                categoryName.text = category.category_name
            }
            if let textView = textViewNotes {
                textView.text = category.notes
            }
            if let amount = textFieldBudgetAmount {
                amount.text = "\(category.amount)"
            }
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


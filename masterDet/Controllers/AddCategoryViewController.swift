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
            configureView()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    let newBudget = Budget(context: context)
    
        if self.textFireldCategoryName.text != "" {
            newBudget.category_name = self.textFireldCategoryName.text
            newBudget.amount = Double(self.textFieldBudgetAmount.text!) ?? 0.0
            newBudget.notes = self.textViewNotes.text
            newBudget.color = self.selectedColor
            newBudget.boarderColor = self.boarderColor
            //save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            //inser an alert if catogoary name not entered
        }
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Budget", in: managedContext)!
        
        var category = NSManagedObject()
        
        if isEditingData {
            category = (editingCategory as? Budget)!
        } else {
            category = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        
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

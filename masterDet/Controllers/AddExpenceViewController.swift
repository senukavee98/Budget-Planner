//
//  AddExpenceViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/21.
//

import UIKit
import CoreData

class AddExpenceViewController: UIViewController {
    
    var budget: Budget?
    var expence: Expence?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickedDate: Date = Date()
    
    @IBOutlet weak var textFieldExpencename: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchEvent: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchEvent.isOn = false
        datePicker.minimumDate = Date()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSelectedDate(_ sender: UIDatePicker) {
        pickedDate = sender.date
    }
    
    @IBAction func handleAddExpence(_ sender: UIButton) {
        let expence = Expence(context: context)
        
        //info for calendar event
        if switchEvent.isOn == true {
        let eventHelper = EventHelper(
            eventName: self.textFieldExpencename.text ?? "",
            date: self.pickedDate,
            notes: self.textViewNotes.text
        )
        
        eventHelper.grantEvent()
        }
        
        expence.expence_name = self.textFieldExpencename.text
        expence.expence_amount = Double(self.textFieldAmount.text ?? "") ?? 0.0
        expence.notes = self.textViewNotes.text
        expence.due_date = self.pickedDate
        budget?.addToExpences(expence)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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

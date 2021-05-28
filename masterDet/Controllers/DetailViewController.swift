//
//  DetailViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/21.
//

import UIKit
import CoreData

struct expenceData {
    let name: String
    let amount: Double
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTotalBudgetValue: UILabel!
    @IBOutlet weak var labelremainingAmount: UILabel!
    @IBOutlet weak var labelSpentAmount: UILabel!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    
    var expenceModel = Expence()
    let pieChart = PieChartView()
    var categoryDetailVC = CatogoryDetailViewController()
    var total_expence_value = 0.0
    {
        didSet{
            labelSpentAmount.text = "\(total_expence_value)"
            labelremainingAmount.text = "\(budget!.amount - total_expence_value)"
        }
    }
    	
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.budget != nil) {
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        } else{
        return 1
}    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.budget != nil) {
            return self.fetchedResultsController.sections?.count ?? 1
        } else {
        return 1
        }
    }
    
    let expenceObj : NSMutableDictionary = NSMutableDictionary()
    var jsonData = NSData()
    var expenceDataArray: NSMutableArray = []

    let color = ColorConverter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenceCell", for: indexPath) as! ExpenceCell
        
        
        if (self.budget != nil) {
            let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].expence_name
            cell.labelExpenceName!.text = title!
            
            let notes = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
            cell.labelNotes.text = notes
            
            let dueDate = self.fetchedResultsController.fetchedObjects?[indexPath.row].due_date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/YYYY"
            cell.LableDueDate?.text = dateformatter.string(from: dueDate ?? Date())

            let amount = self.fetchedResultsController.fetchedObjects?[indexPath.row].expence_amount
            cell.labelExpenceAmount.text = String(amount!)
            
            total_expence_value =  total_expence_value + amount!

                //Progress Bar
            cell.progressBar.progress = Float(amount!/budget!.amount)
            
            if let progressColor = budget?.boarderColor {
                cell.progressBar.tintColor = color.hexStringToUIColor(hex: progressColor)
            }
            

            
        }
        
//         let budget = fetchedResultsController.object(at: indexPath)
//         configureCell(cell, withBudget: budget)
         return cell
    }


    func configureView() {
        // Update the user interface for the detail item.
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 20

        pieChart.frame = CGRect(
            x: 0, y: padding, width: view.frame.size.width, height: 325
            
        )
        
        if let name = budget?.category_name {
            labelCategoryName.text = name
        }
        if let amount = budget?.amount {
            labelTotalBudgetValue.text = "\(amount)"
        }
        if let notes = budget?.notes {
            labelNotes.text = "NOTE: " + notes
        }
        
        
        pieChart.segments = [
            LabelledSegment(color: .red, name: "Red",        value: 57.56),
            LabelledSegment(color: #colorLiteral(red: 1.0, green: 0.541176471, blue: 0.0, alpha: 1.0), name: "Orange",     value: 30),
            LabelledSegment(color: #colorLiteral(red: 0.478431373, green: 0.423529412, blue: 1.0, alpha: 1.0), name: "Purple",     value: 27),
            LabelledSegment(color: #colorLiteral(red: 0.0, green: 0.870588235, blue: 1.0, alpha: 1.0), name: "Light Blue", value: 40),

        ]
        
        pieChart.segmentLabelFont = .systemFont(ofSize: 15)
        
        view.addSubview(pieChart)
        
//        categoryDetailVC.spentAmount = 20.1
        // Do any additional setup after loading the view.
//        self.tableView.register(ExpenceCell.self, forCellReuseIdentifier: "expenceCell")

    }

    var budget: Budget?
    
    
    //MARK: - Detch results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Expence>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Expence> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // buld fetch request
        let fetchRequest: NSFetchRequest<Expence> = Expence.fetchRequest()
        
        //add sort descriptor
        let sortDescriptor = NSSortDescriptor(key: "expence_name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //add the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //add the predicate
        let predicate = NSPredicate(format: "budgetCatoegory = %@", self.budget!)
        fetchRequest.predicate = predicate
        
        //intantiate the results controller""
        let aFetchedResultsController = NSFetchedResultsController<Expence> (
            fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: #keyPath(Expence.expence_name), cacheName: nil
        )
        
        //set delegate
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
        //perform fetch
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unsolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    // MARK: -  Configur the cell
    
    func configureCell(_ cell:UITableViewCell, indexPath: IndexPath) {
        if (self.budget != nil) {
            let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].expence_name
            cell.textLabel?.text = title
//            cell.backgroundColor = self.cellSelColor
            
            if let content = self.fetchedResultsController.fetchedObjects?[indexPath.row].expence_amount{
                cell.detailTextLabel?.text = String(content)
                
            } else {
                cell.detailTextLabel!.text = ""
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "catogoryDetail":
                let destVC = segue.destination as! CatogoryDetailViewController
                if let name = self.budget?.category_name {
                    destVC.categoryName = name
                }
                if let note = self.budget?.notes {
                    destVC.note = note
                }
                if let amount = self.budget?.amount {
                    destVC.totalBudget = amount
                }
                                
            case "addExpence":
                if let budget = self.budget {
                    let destVC = segue.destination as! AddExpenceViewController
                    destVC.budget = budget
                }
                
            default:
                break
            }
        }
        
    }
    
    //MARK: - Controls
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(self.tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    


}


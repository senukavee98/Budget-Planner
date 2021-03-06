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
    let emptyPieChart = PieChartView()
    var categoryDetailVC = CatogoryDetailViewController()
    var editViewController: AddExpenceViewController? = nil
    var total_expence_value = 0.0
    {
        didSet{
            labelSpentAmount.text = " £ \(total_expence_value)"
            labelremainingAmount.text = "£ \(budget!.amount - total_expence_value)"
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
    var otherExpencetotal = 0.0
    let expenceObj : NSMutableDictionary = NSMutableDictionary()
    var jsonData = NSData()
    var expenceDataArray: [Expence] = [] {
        didSet{
            expenceDataArray.sort(by: {$0.expence_amount > $1.expence_amount})
            
            for (index, expence) in expenceDataArray.enumerated() {
                if index < 4 {
                    otherExpencetotal = 0.0
                    pieChart.segments[index].name = expence.expence_name!
                    pieChart.segments[index].value = CGFloat(expence.expence_amount)
                } else {
                    otherExpencetotal = otherExpencetotal + expence.expence_amount;
                    pieChart.segments[4].name = "Other"
                    pieChart.segments[4].value = CGFloat(otherExpencetotal)
                }
         }
            pieChart.segmentLabelFont = .systemFont(ofSize: 15)
            
            view.addSubview(pieChart)
        }
    }
    
    let color = ColorConverter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenceCell", for: indexPath) as! ExpenceCell
        if (self.budget != nil) {
            
            let fetchResultdObject: Expence = (self.fetchedResultsController.fetchedObjects?[indexPath.row])!

            let title = fetchResultdObject.expence_name
            cell.labelExpenceName!.text = title!
            
            let notes = fetchResultdObject.notes
            cell.labelNotes.text = notes
            
            let dueDate = fetchResultdObject.due_date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/YYYY"
            cell.LableDueDate?.text = dateformatter.string(from: dueDate ?? Date())

            let amount = fetchResultdObject.expence_amount
            cell.labelExpenceAmount.text = "£ \(amount)"
            
            total_expence_value =  total_expence_value + amount

                //Progress Bar
            cell.progressBar.progress = Float(amount/budget!.amount)
            
            if let progressColor = budget?.boarderColor {
                cell.progressBar.tintColor = color.hexStringToUIColor(hex: progressColor)
            }

            expenceDataArray.append(fetchResultdObject)
            
        }
        
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
            labelTotalBudgetValue.text = "£ \(amount)"
        }
        if let notes = budget?.notes {
            labelNotes.text = "NOTE: " + notes
        }
        
    
        
        pieChart.segments = [
            LabelledSegment(color: color.hexStringToUIColor(hex: "90caf9"), name: "", value: 0),
            LabelledSegment(color: color.hexStringToUIColor(hex: "ef9a9a"), name: "", value: 0),
            LabelledSegment(color: color.hexStringToUIColor(hex: "aed581"), name: "", value: 0),
            LabelledSegment(color: color.hexStringToUIColor(hex: "ffd54f"), name: "", value: 0),
            LabelledSegment(color: color.hexStringToUIColor(hex: "b39ddb"), name: "", value: 0),
        ]
        emptyPieChart.segments = [
            LabelledSegment(color: .red, name: "No Expense", value: 1.0)
        ]
        
        pieChart.segments[0].color = color.hexStringToUIColor(hex: "90caf9")
        pieChart.segments[0].name = "No Expense"
        pieChart.segments[0].value = 1.0
//
        pieChart.segmentLabelFont = .systemFont(ofSize: 15)

        view.addSubview(pieChart)
//
        
//        categoryDetailVC.spentAmount = 20.1
        // Do any additional setup after loading the view.
//        self.tableView.register(ExpenceCell.self, forCellReuseIdentifier: "expenceCell")

    }

    var budget: Budget?
    
    
    //MARK: - Fetch results controller
    
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
            fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil
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
                
            case "editCategory":
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let object = fetchedResultsController.object(at: indexPath)
                        let controller = segue.destination as! AddExpenceViewController
                        controller.editingExpense = object as Expence
                        editViewController = controller
                        
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


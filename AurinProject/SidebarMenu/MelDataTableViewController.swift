//
//  MelDataTableViewController.swift
//  AurinProject
//
//  Created by tiehuaz on 8/29/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

/* First Visualizaiton interface based on retured data, listing all data in melbourne area
*/

class MelDataTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!

    @IBOutlet var myTable: UITableView!
    let textCellIdentifier = "TextCell"
    let user = Singleton.sharedInstance
    var testCount : Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadStockQuoteItems"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        myTable.rowHeight = 40
        
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "\(user.totalDataMelb.count) data in Melbourne Area"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return user.totalDataMelb.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let data : Dictionary<String,AnyObject> =  user.totalDataMelb[indexPath.row] as! Dictionary
        let id : AnyObject = data["id"]!
        if user.flag == 1{
             cell.textLabel!.font = UIFont.systemFontOfSize(14.0)
        }else if user.flag == 2{
            cell.textLabel!.font = UIFont.systemFontOfSize(12.0)
        }
        cell.textLabel?.text = id as?String
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if(user.flag==0){
            self.performSegueWithIdentifier("income_show", sender: self)
            
        }else if(user.flag==1){
            self.performSegueWithIdentifier("population_show", sender: self)
            
        }else if(user.flag==2){
            self.performSegueWithIdentifier("alcohol_show", sender: self)
        }
        
    }
    
    @IBAction func returnButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func loadStockQuoteItems() {
        tableView.reloadData()
        self.navigationItem.title = "\(user.totalDataMelb.count) data in Melbourne Area"
        refreshControl?.endRefreshing()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!

        let data : Dictionary<String,AnyObject> =  user.totalDataMelb[indexPath.row] as! Dictionary
        let id : String = data["id"]! as! String
        let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
        var stringArr = id.componentsSeparatedByString(".")
        if segue.identifier == "income_show"{
    
            
            let destination : DataShowingIncome = segue.destinationViewController as! DataShowingIncome
            
            destination.fakeID = stringArr[1]
           
            destination.fakeCode = properties["sla_code"] as! String
            destination.fakeName = properties["sla_name"] as! String
            destination.fakeYear1 = properties["housingstress_06"]?.stringValue
            destination.fakeYear2 = properties["housingstress_10"]?.stringValue
            destination.differ = properties["housingstress_difference"]?.stringValue
            destination.low = properties["income_low"]?.stringValue
            destination.mid = properties["income_middle"]?.stringValue
            destination.high = properties["income_high"]?.stringValue

        }else if segue.identifier == "population_show"{
            
            let destination :DataShowingPopulation = segue.destinationViewController as! DataShowingPopulation
            destination.fakeID = stringArr[1]
            destination.fakeName = properties["lga_name"] as! String
            destination.fakeCode = properties["lga_code"]?.stringValue
            destination.fakeState = properties["state_name"] as! String
            destination.fakeMale = properties["All_Male"]?.stringValue
            destination.fakeFemale = properties["All_Female"]?.stringValue
            destination.fakeTotal = properties["All_Person"]?.stringValue

            
        }else if segue.identifier == "alcohol_show"{
        
            let destination :DataShowingAlcohol = segue.destinationViewController as! DataShowingAlcohol
            destination.fakeCode = properties["lga_code06"]?.stringValue
            destination.fakeName = properties["lga_name06"] as! String
            destination.fakeNum = properties["numeric"]?.stringValue
            destination.fakeNumLow = properties["ci_low"]?.stringValue
            destination.fakeNumHigh = properties["ci_high"]?.stringValue
            destination.fakeSig = properties["significance"] as! String
        }
    }

}

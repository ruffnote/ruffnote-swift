//
//  SelectNoteViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/12.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class SelectNoteViewController: UITableViewController, UISearchResultsUpdating {

    var notes = [Note]()

    var searchController: UISearchController!
    var searchResults = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Select note", comment: "")
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelItemDidTap:")
        self.navigationItem.leftBarButtonItem = cancelItem
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")


        let searchResultsController = UITableViewController(style: .Plain)
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController.searchResultsUpdater = self

        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar

        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        SVProgressHUD.show()
        RuffnoteAPIClient.sharedClient.notes(
            accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
            success: { (notes: [Note]) in
                self.notes = notes
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            },
            failure: { (message: String) in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error", comment: ""),
                    message: message,
                    preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(
                    title: NSLocalizedString("OK", comment: ""),
                    style: .Default,
                    handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                SVProgressHUD.dismiss()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func cancelItemDidTap(sender: AnyObject!) {
        self.close()
    }
    
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.notes.count + 1
        } else {
            return self.searchResults.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if tableView == self.tableView {
            if indexPath.row < self.notes.count {
                let note = self.notes[indexPath.row]
                cell.textLabel?.text = note.label
            } else {
                cell.textLabel?.text = NSLocalizedString("New note", comment: "")
            }
        } else {
            let note = self.searchResults[indexPath.row]
            cell.textLabel?.text = note.label
        }

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        } else if editingStyle == .Insert {
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            if indexPath.row < self.notes.count {
                let note = self.notes[indexPath.row]
                AppConfiguration.sharedConfiguration.setCurrentNote(note)
                self.close()
            } else {
                let newNoteController = NewNoteViewController()
                self.navigationController?.pushViewController(newNoteController, animated: true)
            }
        } else {
            let note = self.searchResults[indexPath.row]
            AppConfiguration.sharedConfiguration.setCurrentNote(note)
            self.close()
        }
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchString = self.searchController.searchBar.text
        
        self.searchResults = self.notes.filter { note in
            if let range = note.label.rangeOfString(searchString, options: .CaseInsensitiveSearch) {
                return true
            } else {
                return false
            }
        }
        
        let tableViewController = self.searchController.searchResultsController as UITableViewController
        tableViewController.tableView.reloadData()
    }
}

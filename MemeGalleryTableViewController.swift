//
//  MemeGalleryTableViewController.swift
//  Meme-Me V1
//
//  Created by Calum Harris on 14/04/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class MemeGalleryTableViewController: UITableViewController {

  // MARK : View cycles and properties.
  
  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }
  
  
  override func viewWillAppear(animated: Bool) {
    tableView.reloadData()
  }
  
}







extension MemeGalleryTableViewController {
  

  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return memes.count
  }
  
  

   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCellWithIdentifier("memeDetail", forIndexPath: indexPath)
   
   // Configure the cell...
   cell.imageView?.image = memes[indexPath.row].meMeImage
   let text = memes[indexPath.row]
   cell.textLabel?.text = "\(text.topText) \(text.bottomText)"
    
   return cell
   }
 
  
}





extension MemeGalleryTableViewController {
  
  // MARK: - Navigation
  
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   
    if segue.identifier == "tableSegue" {
      let destinationSegue = segue.destinationViewController as! DetailViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
        destinationSegue.selectedMeme = memes[indexPath.row]
        
      }
    }
   }
 
}

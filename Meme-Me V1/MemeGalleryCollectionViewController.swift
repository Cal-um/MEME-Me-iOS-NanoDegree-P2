//
//  MemeGalleryCollectionViewController.swift
//  Meme-Me V1
//
//  Created by Calum Harris on 14/04/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class MemeGalleryCollectionViewController: UICollectionViewController {
  
  // MARK: Life cycles and properties.
  
  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }
  
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  
  override func viewWillAppear(animated: Bool) {
    collectionView!.reloadData()
    

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let spacing: CGFloat = 3
    let dimension = (view.frame.size.width - (2 * spacing)) / 3.0
    
    flowLayout.minimumLineSpacing = spacing
    flowLayout.minimumInteritemSpacing = spacing
    flowLayout.itemSize = CGSizeMake(dimension, dimension)
  }
  
}



extension MemeGalleryCollectionViewController {
  
  // MARK: CollectionView data source.
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
    cell.memePhotoOutlet.image = memes[indexPath.row].meMeImage
    
    return cell
  }
  
  
}



extension MemeGalleryCollectionViewController {
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "detailCollectionView" {
      let destinationSegue = segue.destinationViewController as! DetailViewController
      
      if let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
        destinationSegue.selectedMeme = memes[indexPath.item]
        
      }
    }
  }
  
}

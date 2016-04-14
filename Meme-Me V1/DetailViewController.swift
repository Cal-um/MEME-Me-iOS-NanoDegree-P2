//
//  DetailViewController.swift
//  Meme-Me V1
//
//  Created by Calum Harris on 14/04/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var selectedMeme: Meme!
  
  @IBOutlet weak var memePhoto: UIImageView!
  
  override func viewDidLoad() {
    memePhoto.image = selectedMeme.meMeImage
  }
  
}
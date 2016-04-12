//
//  ViewController.swift
//  Meme-Me V1
//
//  Created by Calum Harris on 12/04/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class PickAndEditViewController: UIViewController {
  
  // MARK: Properties and view cycles

  @IBOutlet weak var cameraOutlet: UIBarButtonItem!
  @IBOutlet weak var chooseFromAlbumOutlet: UIBarButtonItem!
  @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
  @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
  
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var imageViewOutlet: UIImageView!
  
  let textFieldAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 27.0)!, NSStrokeWidthAttributeName : 3.0, NSStrokeColorAttributeName : UIColor.blackColor()]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    congifureTextFields()

  }

}



extension PickAndEditViewController: UITextFieldDelegate {
  
  // MARK: textField configuration
  
  func congifureTextFields() {
    
    topTextField.delegate = self
    topTextField.defaultTextAttributes = textFieldAttributes
    let topText = NSAttributedString(string: "Top", attributes: textFieldAttributes)
    topTextField.attributedPlaceholder = topText
    topTextField.textAlignment = .Center
    
    bottomTextField.delegate = self
    bottomTextField.textAlignment = .Center
    let bottomText = NSAttributedString(string: "Bottom", attributes: textFieldAttributes)
    bottomTextField.attributedPlaceholder = bottomText

    
    bottomTextField.defaultTextAttributes = textFieldAttributes
    bottomTextField.textAlignment = .Center
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    topTextField.resignFirstResponder()
    bottomTextField.resignFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(textField: UITextField) {
    topTextField.attributedPlaceholder = nil
    bottomTextField.attributedPlaceholder = nil
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    congifureTextFields()
  }
  
  
}






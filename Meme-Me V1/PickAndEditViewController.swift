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
  
  let textFieldAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!, NSStrokeWidthAttributeName : -3.0, NSStrokeColorAttributeName : UIColor.blackColor()]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    congifureTextFields()
    cameraOutlet.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
  }
  
  override func viewDidAppear(animated: Bool) {
   subscribeToKeyboardNotifications()
  }
  
  override func viewDidDisappear(animated: Bool) {
    unsubscribeToNotifications()  
  }

}







extension PickAndEditViewController: UITextFieldDelegate {
  
  // MARK: textField and keyboard configuration
  
  func congifureTextFields() {
    
    topTextField.delegate = self
    topTextField.defaultTextAttributes = textFieldAttributes
    let topText = NSAttributedString(string: "TOP", attributes: textFieldAttributes)
    topTextField.attributedPlaceholder = topText
    topTextField.textAlignment = .Center
    
    bottomTextField.delegate = self
    let bottomText = NSAttributedString(string: "BOTTOM", attributes: textFieldAttributes)
    bottomTextField.attributedPlaceholder = bottomText
    bottomTextField.defaultTextAttributes = textFieldAttributes
    bottomTextField.textAlignment = .Center
    
  }
  
  //  remove placeholder when inputing text and return will dismiss keyboard
  
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
  
  // Subscribe to keyboard notifications and move view the height of the keyboard if bottomTextView is first responder.
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
     NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeToNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
    view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
    view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
}





extension PickAndEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: Pick an Image

  @IBAction func takeAPicture(sender: AnyObject) {
    
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera
    presentViewController(imagePicker, animated: true, completion: nil)
    
  }
  
  
  @IBAction func chooseImageFromAlbum(sender: AnyObject) {
    
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .SavedPhotosAlbum
    presentViewController(imagePicker, animated: true, completion: nil)

  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    dismissViewControllerAnimated(true, completion: nil)

    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
    imageViewOutlet.image = image 
    
    }
    
  }
  
  
}






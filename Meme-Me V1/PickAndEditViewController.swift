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
  
  @IBOutlet weak var toolBar: UIToolbar!
  
  // Text attributes for NSAttributedString defaultTextAttributes
  
  let textFieldAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50.0)!, NSStrokeWidthAttributeName : -3.0, NSStrokeColorAttributeName : UIColor.blackColor()]
  
  
  // View cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    congifureTextFields(topTextField)
    congifureTextFields(bottomTextField)
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
  
  func congifureTextFields(textField: UITextField) {
    
    var placeholderString = ""
    
    switch textField {
    case topTextField: placeholderString = "TOP"
    case bottomTextField: placeholderString = "BOTTOM"
    default: print("unacounted for textField")
    }
    
    textField.delegate = self
    textField.defaultTextAttributes = textFieldAttributes
    let text = NSAttributedString(string: placeholderString, attributes: textFieldAttributes)
    textField.attributedPlaceholder = text
    textField.textAlignment = .Center
  
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
    congifureTextFields(topTextField)
    congifureTextFields(bottomTextField)
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
  
  // When notifications sent out these functions will be called
  
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
  
  // Keyboard height calculation
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
}







extension PickAndEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: Pick an Image

  
  // camera
  
  
  @IBAction func takeAPicture(sender: AnyObject) {
    imagePicker(sender as! UIBarButtonItem)
  }
  
  
  // album
  
  @IBAction func chooseImageFromAlbum(sender: AnyObject) {
    imagePicker(sender as! UIBarButtonItem)
  }
  
  
  // Image Picker function camera/album 
  
  func imagePicker(sender: UIBarButtonItem) {
    
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    switch sender {
    case cameraOutlet: imagePicker.sourceType = .Camera
    case chooseFromAlbumOutlet: imagePicker.sourceType = .PhotoLibrary
    default: print("Unkown Button")
    }
    
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  
  
  // orginal image sent to image outlet
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    dismissViewControllerAnimated(true, completion: nil)

    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
    imageViewOutlet.image = image 
    shareButtonOutlet.enabled = true
    }
  }
  
  // MARK: Save and generate meme image
  
  
  func save() {
    let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
      imageViewOutlet.image!, meMeImage: memedImage())
  }
  
  // screenshot of combined text and image minus navbar and toolbar.
  
  func memedImage() -> UIImage {
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    toolBar.hidden = true
    
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawViewHierarchyInRect(self.view.frame,
                                 afterScreenUpdates: true)
    let memedImage : UIImage =
      UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    toolBar.hidden = false
    return memedImage

  }
  
  // Action view controller with save and dismiss in completion handler.
  
  @IBAction func shareImage(sender: AnyObject) {
    
    let actionController = UIActivityViewController(activityItems: [memedImage()], applicationActivities: nil)
    presentViewController(actionController, animated: true, completion: nil)
    
    actionController.completionWithItemsHandler = { activity, success, items, error in
      
      if success {
        print("Success")
        self.save()
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  // cancel button removes all user added content
  
  @IBAction func resetToInitalSettings(sender: AnyObject) {
    
    shareButtonOutlet.enabled = false
    topTextField.text = ""
    bottomTextField.text = ""
    imageViewOutlet.image = nil
  }
  
  

  
}






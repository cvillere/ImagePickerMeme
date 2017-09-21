//
//  ViewController.swift
//  ImagePickerMeme
//
//  Created by Christian Villere on 9/11/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate {
    
    
    //MARK : Properties
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0]
    
    
    
    //MARK : Outlets
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickAnImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navShareButton: UIBarButtonItem!
    
    //MARK : Actions
    
    @IBAction func shareButton(_ sender: Any) {
        
        //item to share; the memed image
        let meme = generateMemedImage()
        
        //setting up activityViewController
        let memeToShare = [meme]
        let activityViewController = UIActivityViewController(activityItems: memeToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view //so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        //dismiss the view controller
        
        
        //saving the meme
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                print("saved")
            
        }
      }
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    //MARK : Struct
    
    struct memeObject {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
        }
    
    
    //MARK : Meme Object
    
    func save() {
        // Create the meme
        let meme = memeObject(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    

    
    
    func generateMemedImage() -> UIImage {
        
        
        // TODO: Hide toolbar and navbar
        self.toolBar.isHidden = true
        self.navBar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        // TODO: Show toolbar and navbar
        self.toolBar.isHidden = false
        self.navBar.isHidden = false
        
        
        return memedImage
    }
    

    
    
    
    
    //MARK : LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        navShareButton.isEnabled = (imagePickerView.image != nil)
        subscribeToKeyboardNotifications()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = chosenImage
    
        }

        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            unsubscribeFromKeyboardNotifications()
        }
        textField.text = ""

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            subscribeToKeyboardNotifications()
        }

    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
        
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    
    }
    

    
    func keyboardWillShow(_ notification:Notification) {
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    
    func keyboardWillHide(_ notification:Notification) {
        
        if view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
            
        }

    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

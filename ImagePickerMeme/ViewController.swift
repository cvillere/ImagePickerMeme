//
//  ViewController.swift
//  ImagePickerMeme
//
//  Created by Christian Villere on 9/11/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate, UITableViewDataSource {
    
    
    //MARK : Properties
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0]
    
    var memes = [memeObject]()
    
    
    
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
        

        
        
        //saving the meme
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                print("saved")
            
        }
      }
    }
    
    //function created to refactor code from two below buttons
    func pickImage (sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        

        pickImage(sourceType: .camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        

        pickImage(sourceType: .photoLibrary)
        
    }
    
    //MARK: present method used to present the meme editor
    func present(_ viewControllerToPresent: ViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        let viewControllerToPresent = ViewController()
        present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    
    //MARK : Meme Object
    
    func save() {
        // Create the meme
        let meme = memeObject(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        //Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //function created to refactor hiding and showing tool and nav bars
    func toolNavBool(Bool: Bool ) {
        self.toolBar.isHidden = Bool
        self.navBar.isHidden = Bool
        
        
    }
    
    
    func generateMemedImage() -> UIImage {
        
        
        // TODO: Hide toolbar and navbar
        toolNavBool(Bool: true)
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        // TODO: Show toolbar and navbar
        toolNavBool(Bool: false)
        
        
        return memedImage
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "TopText: \(meme.topText)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! memeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
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
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, space, pickAnImageButton, space, cameraButton, space, space]
        
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


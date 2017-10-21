//
//  memeCollectionView.swift
//  ImagePickerMeme
//
//  Created by Christian Villere on 10/15/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class memeCollectionViewController: UIViewController {
    
    
    
    

    //MARK: present method used to present the meme editor
    func present(_ viewControllerToPresent: ViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let memeEditorView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.present(memeEditorView, animated: true, completion: nil)
        }
    
    }
    
    
    
    
}

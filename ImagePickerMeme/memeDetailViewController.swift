//
//  memeDetailView.swift
//  ImagePickerMeme
//
//  Created by Christian Villere on 10/15/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VillainDetailViewController: UIViewController

class memeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: memeObject!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.label.text = self.meme.topText
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = UIImage(named: meme.bottomText)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

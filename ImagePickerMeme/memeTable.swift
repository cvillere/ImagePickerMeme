//
//  UITableViewController.swift
//  ImagePickerMeme
//
//  Created by Christian Villere on 10/21/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit


class memeTable: UITableViewController {
    
    
    //MARK: properties
    var memes = [memeObject]()
    
    
    
    //MARK: Outlets
    
    @IBOutlet weak var memeView: UITableView!
    
    
    
    //MARK: Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! memeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    //MARK: present method used to present the meme editor
    
//    func present(_ viewControllerToPresent: ViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        if let memeEditorView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController {
//            self.present(memeEditorView, animated: true, completion: nil)
//        }
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let memeEditorView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController {
            present(memeEditorView, animated: true, completion: nil)
            
        }
    }
    
}

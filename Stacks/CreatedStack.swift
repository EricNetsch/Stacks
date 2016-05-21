//
//  CreatedStack.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class CreatedStack: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["family2.png", "family4.png", "family6.png", "family1.png", "family3.png", "family5.png", "r2.png", "family7.png"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var printBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        printBtn.layer.cornerRadius = 10
        printBtn.layer.borderWidth = 2
        printBtn.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CreatedStackCell
        
        cell.stackImages.image = UIImage(named: items[indexPath.row])
        cell.stackImages.layer.cornerRadius = 5
        cell.stackImages.clipsToBounds = true
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    

    @IBAction func closeCreatedStack(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func printPressed(sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Print Option", preferredStyle: .ActionSheet)
        
        let blockAction = UIAlertAction(title: "Snapfish", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        
        let flagAction = UIAlertAction(title: "Shutterfly", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            //TODO: Flag User Function
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        optionMenu.addAction(blockAction)
        optionMenu.addAction(flagAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    


}

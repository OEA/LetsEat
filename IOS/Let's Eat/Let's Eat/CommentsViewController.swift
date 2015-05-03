//
//  CommentsViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 13.04.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var comments: [[String: AnyObject]]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(comments)
        return comments.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CommentCell", forIndexPath: indexPath) as! UICollectionViewCell
        if comments.count > 0 {
            let width = self.view.frame.width - 8
            let textView = cell.viewWithTag(99) as! UITextView
            let textOwnerLabel = cell.viewWithTag(90) as! UILabel
            let commentText = comments[indexPath.item]["content"] as! String
            let owner = comments[indexPath.item]["owner"] as! [String: AnyObject]
            let ownerText = owner["username"] as! String
            if !ownerText.isEmpty {
                textOwnerLabel.text = ownerText
            }
            if !commentText.isEmpty {
                textView.text = commentText
            }
            cell.frame = CGRect(x: 0, y: 0, width: width, height: textView.frame.height*2)
        }
        return cell
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

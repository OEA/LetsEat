//
//  CreateEventViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 27.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typePV: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePV: UIDatePicker!
    
    var types = ["Drink", "Food"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDatePicker()
    }
    
    func configureDatePicker() {
        let now = NSDate()
        datePV.minimumDate = now
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func typeTapped(sender: UIButton) {
        typePV.hidden = !typePV.hidden
        doneButton.hidden = !doneButton.hidden
        if typePV.selectedRowInComponent(0) == 0 {
            typeButton.setTitle(types[0], forState: .Normal)
            typeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return types[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeButton.setTitle(types[row], forState: .Normal)
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

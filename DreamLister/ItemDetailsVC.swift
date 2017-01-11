//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Sang Saephan on 1/9/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var detailsTextField: CustomTextField!
    @IBOutlet weak var storePickerView: UIPickerView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove title from navigation bar's back-button
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePickerView.delegate = self
        storePickerView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        /*let store1 = Store(context: context)
        store1.name = "Apple Store"
        
        let store2 = Store(context: context)
        store2.name = "Best Buy"
        
        let store3 = Store(context: context)
        store3.name = "Walmart"
        
        let store4 = Store(context: context)
        store4.name = "Target"
        
        let store5 = Store(context: context)
        store5.name = "Amazon"
        
        ad.saveContext()*/
        getStores()
        
        // If item to edit is not nil, load the item into the text fields
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePickerView.reloadAllComponents()
        } catch {
            
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var item: Item!
        let image = Image(context: context)
        image.image = thumbnailImageView.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = image
        
        if let title = titleTextField.text {
            item.name = title
        }
        
        if let price = Double(priceTextField.text!) {
            item.price = price
        }
        
        if let details = detailsTextField.text {
            item.details = details
        }
        
        item.toStore = stores[storePickerView.selectedRow(inComponent: 0)]
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // Populate text fields with existing item
    func loadItemData() {
        if let item = itemToEdit {
            titleTextField.text = item.name
            priceTextField.text = "\(item.price)"
            detailsTextField.text = item.details
            thumbnailImageView.image = item.toImage?.image as! UIImage?
            
            if let store = item.toStore {
                var index = 0
                while index < stores.count {
                    if store.name == stores[index].name {
                        storePickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }
            }
        }
    }
    
    // Delete the selected item
    @IBAction func deletePressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
           _ = navigationController?.popViewController(animated: true)
            ad.saveContext()
        }
    }
    
    // Display the new image onto the thumbnail image view
    @IBAction func selectNewImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Select image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

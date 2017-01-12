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
    @IBOutlet weak var itemTypePickerView: UIPickerView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var itemType: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
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
        
        itemTypePickerView.delegate = self
        itemTypePickerView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // If context contains Stores, don't add duplicates
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            if try context.count(for: storeFetchRequest) == 0 {
                let store1 = Store(context: context)
                store1.name = "Amazon"
                
                let store2 = Store(context: context)
                store2.name = "Apple Store"
                
                let store3 = Store(context: context)
                store3.name = "Best Buy"
                
                let store4 = Store(context: context)
                store4.name = "Target"
                
                let store5 = Store(context: context)
                store5.name = "Walmart"
                
                ad.saveContext()
            }
        } catch {
            let error = NSError.self
            print(error)
        }
        
        // If context contains ItemTypes, don't add duplicates
        let itemTypeFetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            if try context.count(for: itemTypeFetchRequest) == 0 {
                let itemType1 = ItemType(context: context)
                itemType1.type = "Automobile"
                
                let itemType2 = ItemType(context: context)
                itemType2.type = "Clothing"
                
                let itemType3 = ItemType(context: context)
                itemType3.type = "Electronics"
                
                let itemType4 = ItemType(context: context)
                itemType4.type = "Furniture"
                
                let itemType5 = ItemType(context: context)
                itemType5.type = "Toys"
                
                let itemType6 = ItemType(context: context)
                itemType6.type = "Other"
                
                ad.saveContext()
            }
        } catch {
            let error = NSError.self
            print(error)
        }
        
        getStores()
        getItemTypes()
        
        // If item to edit is not nil, load the item into the text fields
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == storePickerView {
            return stores.count
        } else {
            return itemTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == storePickerView {
            let store = stores[row]
            return store.name
        } else {
            let itemType = itemTypes[row]
            return itemType.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == storePickerView {
            storeButton.setTitle(stores[storePickerView.selectedRow(inComponent: 0)].name, for: .normal)
        } else {
            itemType.setTitle(itemTypes[itemTypePickerView.selectedRow(inComponent: 0)].type, for: .normal)
        }
    }
    
    // Retrieve Stores from context
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePickerView.reloadAllComponents()
        } catch {
            
        }
    }
    
    // Retrieve ItemTypes from context
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.itemTypePickerView.reloadAllComponents()
        } catch {
            
        }
    }
    
    // Add/update item into memory
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
        item.toItemType = itemTypes[itemTypePickerView.selectedRow(inComponent: 0)]
        
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
                        storeButton.setTitle(stores[storePickerView.selectedRow(inComponent: 0)].name, for: .normal)
                        break
                    }
                    index += 1
                }
            }
            
            if let itemType = item.toItemType {
                var index = 0
                while index < stores.count {
                    if itemType.type == itemTypes[index].type {
                        itemTypePickerView.selectRow(index, inComponent: 0, animated: false)
                        self.itemType.setTitle(itemTypes[itemTypePickerView.selectedRow(inComponent: 0)].type, for: .normal)
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
    
    // Display UIPickerView for ItemType
    @IBAction func itemTypePressed(_ sender: Any) {
        self.navigationController?.visibleViewController?.view.backgroundColor = UIColor(red: 0.46, green: 0.11, blue: 0.08, alpha: 0.40)
        
        itemTypePickerView.isHidden = false
        okayButton.isHidden = false
        
        itemType.isHidden = true
        itemTypeLabel.isHidden = true
        storeLabel.isHidden = true
        storeButton.isHidden = true
        
        thumbnailImageView.alpha = 0.40
        priceTextField.alpha = 0.40
        detailsTextField.alpha = 0.40
        titleTextField.alpha = 0.40
        saveButton.alpha = 0.40
    }
    
    // Display UIPickerView for Store
    @IBAction func storePressed(_ sender: Any) {
        self.navigationController?.visibleViewController?.view.backgroundColor = UIColor(red: 0.46, green: 0.11, blue: 0.08, alpha: 0.40)
        
        storePickerView.isHidden = false
        okayButton.isHidden = false
        
        itemType.isHidden = true
        itemTypeLabel.isHidden = true
        storeLabel.isHidden = true
        storeButton.isHidden = true
        
        thumbnailImageView.alpha = 0.40
        priceTextField.alpha = 0.40
        detailsTextField.alpha = 0.40
        titleTextField.alpha = 0.40
        saveButton.alpha = 0.40
    }
    
    // Hide picker views
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.navigationController?.visibleViewController?.view.backgroundColor = UIColor(red: 0.46, green: 0.11, blue: 0.08, alpha: 1)
        
        storePickerView.isHidden = true
        itemTypePickerView.isHidden = true
        okayButton.isHidden = true
        
        itemType.isHidden = false
        storeButton.isHidden = false
        itemTypeLabel.isHidden = false
        storeLabel.isHidden = false
        
        thumbnailImageView.alpha = 1
        priceTextField.alpha = 1
        detailsTextField.alpha = 1
        titleTextField.alpha = 1
        saveButton.alpha = 1
    }
    
    
    
    // Select image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

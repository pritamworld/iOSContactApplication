//
//  ReadContactViewController.swift
//  MyContactApplication
//
//  Created by moxDroid on 2019-03-20.
//  Copyright © 2019 moxDroid. All rights reserved.
//

import UIKit
import ContactsUI

class ReadContactViewController: UIViewController, CNContactPickerDelegate {
    @IBOutlet weak var imgContactPhoto: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnGetContact = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.getContactClick))
        self.navigationItem.title = "Get Contact"
        self.navigationItem.rightBarButtonItem = btnGetContact
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func getContactClick() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancelled..")
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            
            
            
            print("Name : \(contact.givenName) \(contact.familyName)")
            
            self.lblName.text = "\(contact.givenName) \(contact.familyName)"
            
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
                print("number is = \(phoneNumber.stringValue)")
                self.lblPhoneNumber.text = phoneNumber.stringValue
            }
            
           
            if contact.emailAddresses.count != 0 {
                print("Email: \(String(describing: contact.emailAddresses[0].value))")
                
                self.lblEmail.text = String(describing: contact.emailAddresses[0].value)
            }else{
                self.lblEmail.text = "No Email Found"
                self.lblEmail.textColor = #colorLiteral(red: 1, green: 0.1206318487, blue: 0.1925075282, alpha: 1)
            }
            
            self.imgContactPhoto.setRounded()
            if contact.imageDataAvailable{
                self.imgContactPhoto?.image = UIImage(data: contact.imageData!)
            }else{
                self.imgContactPhoto?.image = #imageLiteral(resourceName: "no_person.png")
            }
        }
    }
}

//
//  ViewController.swift
//  MyContactApplication
//
//  Created by moxDroid on 2019-03-20.
//  Copyright © 2019 moxDroid. All rights reserved.
//  Add Privacy entry to info.plist

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
    
    @IBOutlet weak var myContactTableView: UITableView!
    
    var contacts = [CNContact]()
    var store = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myContactTableView.dataSource = self
        myContactTableView.delegate = self
        getContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func getContacts() {
        store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            self.store.requestAccess(for: .contacts, completionHandler: { (authorized, error)  in
                if authorized {
                    self.retrieveContactsWithStore(store: self.store)
                }
                })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: self.store)
        }
    }

    func retrieveContactsWithStore(store: CNContactStore) {
        print("Allow")
        do {
            let groups = try store.groups(matching: nil)
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
           
            // contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            
            getAllContacts()
            
            //displayContacts()
            
            /*
            self.objects = contacts
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.tableView.reloadData()
            })
             */
        } catch {
            print(error)
        }
    }
    
    func getAllContacts(){
     contacts = [CNContact]()
        do
        {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor])
            try store.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                
                DispatchQueue.main.async {
                    //self.contacts = [cnContact]
                    //self.displayContacts()
                    self.contacts.append(cnContact)
                    self.myContactTableView.reloadData()
                }
                
            })
            
        } catch {
            print("Error fetching contacts...")
        }
        
        
    }
    
    func displayContacts()
    {
        for contact in contacts{
            print("Name : \(contact.givenName)")
            if contact.emailAddresses.count != 0 {
                print("Email: \(String(describing: contact.emailAddresses[0].value))")
            }
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        cell.detailTextLabel?.textColor = UIColor.blue
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text =  "\(contact.givenName) \(contact.familyName)"
        
        if contact.emailAddresses.count != 0 {
            cell.detailTextLabel?.text = String(describing: contact.emailAddresses[0].value)
        }else{
            cell.detailTextLabel?.text = "No Email Found"
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
        cell.imageView?.setRounded()
        if contact.imageDataAvailable{
            cell.imageView?.image = UIImage(data: contact.imageData!)
        }else{
            cell.imageView?.image = #imageLiteral(resourceName: "no_person.png")
        }
        
        
        
        return cell
        
    }
}

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}


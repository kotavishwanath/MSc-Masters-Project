//
//  RegestrationViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 18/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//  https://www.youtube.com/watch?v=nfHBCQ3c4Mg
//  https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial Coredata
//  https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field For showing and hiding the keyboard

import UIKit
import CoreData

// patients.value(forKeyPath: "name") as? String

class RegestrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {

    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    
    var patients:[NSManagedObject] = []
    @IBOutlet weak var formScrollView: UIScrollView!
    var activeField: UITextField?
    
    let imagepickerController = UIImagePickerController()
    //Outlet connections
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var patientname: UILabel!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var maidenname: UITextField!
    @IBOutlet weak var dateofbirth: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var displayname: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var mobilenumber: UITextField!
    @IBOutlet weak var emercontactname: UITextField!
    @IBOutlet weak var emercontactnumber: UITextField!
    @IBOutlet weak var emercontactemail: UITextField!
    @IBOutlet weak var emercontactrelationship: UITextField!
    @IBOutlet weak var pinnumber: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenterpassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //     navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        imagepickerController.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        submitBtn.layer.borderWidth = 1.5
        submitBtn.layer.borderColor = UIColor.blue.cgColor
        submitBtn.layer.cornerRadius = 4.0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func openCamerabutton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagepickerController.sourceType = .camera
            self.present(imagepickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not Avaliable", message: "Camera is not accessiable for your device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openGalleryButton(_ sender: Any) {
        imagepickerController.sourceType = .photoLibrary
        self.present(imagepickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let profileImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageview.image = profileImage
        dismiss(animated: true, completion: nil)
        
        /*
         In future for resizing the image inorder to reduce the size of the image file
         let image = resizeImage(profileImage, newWidth: 140)
         let imgData = profileImage.pngData()
         // let byteData = [UInt8](repeating: 0x0, count: imgData!.count)
         
         let tmpImg = UIImage(data: imgData!)!
         let resizedImg = UIImage(cgImage: tmpImg.cgImage!, scale: image.scale, orientation: image.imageOrientation)
         profileImageview.image = resizedImg
         */
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage
    {
//        let scale = newWidth / image.size.width
//        let newHeight = image.size.height * scale
        let newHeight = CGFloat(150.0)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func randomNumberWith(digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "PatientsContactInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        if (firstname.text != "" && lastname.text != "" && maidenname.text != "" && dateofbirth.text != "" && email.text != "" && displayname.text != "" && address1.text != "" && state.text != "" && country.text != "" && postcode.text != "" && mobilenumber.text != "" && emercontactname.text != "" && emercontactnumber.text != "" && emercontactemail.text != "" && emercontactrelationship.text != "" && pinnumber.text != "" && username.text != "" && password.text != "" && reenterpassword.text != "" && (password.text == reenterpassword.text)){
            
            let validemail = isValidEmail(testStr: email.text!)
            let validemeremail = isValidEmail(testStr: emercontactemail.text!)
            if validemail && validemeremail{
                person.setValue(firstname.text, forKey: "first_name")
                person.setValue(lastname.text, forKey: "last_name")
                person.setValue(maidenname.text, forKey: "mothers_madin_name")
                person.setValue(dateofbirth.text, forKey: "dob")
                person.setValue(email.text, forKey: "email")
                person.setValue(displayname.text, forKey: "display_name")
                let address = address1.text! + "\n" + address2.text!
                person.setValue(address, forKey: "address")
                person.setValue(state.text, forKey: "state")
                person.setValue(country.text, forKey: "country")
                person.setValue(postcode.text, forKey: "postcode")
                person.setValue(Int64(mobilenumber.text!), forKey: "mobile_number")
                person.setValue(emercontactname.text, forKey: "emergency_contact_name")
                person.setValue(Int64(emercontactnumber.text!), forKey: "emergency_contact_number")
                person.setValue(emercontactemail.text, forKey: "emergency_contact_email")
                person.setValue(emercontactrelationship.text, forKey: "emergency_contact_relationship")
                person.setValue(Int16(pinnumber.text!), forKeyPath: "pin_number")
                person.setValue(username.text, forKeyPath: "username")
                person.setValue(password.text, forKeyPath: "password")
                
                
                let uhiNumber = randomNumberWith(digits: 5)
                print(uhiNumber)
                //need to save this number and is used as the Universal Health Identifier number.
                
                person.setValue(uhiNumber, forKeyPath: "uhi")
                //        _ = profileImageview.image?.pngData() as NSData?
                person.setValue(profileImageview.image!.pngData() as NSData?, forKey: "profile_picture")
                
            }else{
                let alert = UIAlertController(title: "Not Valid", message: "Please provide the valid email address", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           
        }else{
            let alert = UIAlertController(title: "Not Valid", message: "Please enter all the mandatory fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        // 4
        do {
            try managedContext.save()
            patients.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //Keyboard stuff
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.formScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.formScrollView.contentInset = contentInsets
        self.formScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.formScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.formScrollView.contentInset = contentInsets
        self.formScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //self.formScrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}

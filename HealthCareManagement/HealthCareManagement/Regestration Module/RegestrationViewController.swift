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
/**
 This class is used for the patient regestration purpose
 */
class RegestrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
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
    ///Causes the view (or one of its embedded text fields) to resign the first responder status.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    /**
     When the user clicked on back button app will be navigating to the Front view controller
     */
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     User can also update there profile picture by taking the photo right away using the camera
     */
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
    /**
     User will be selecting profile picture from there gallery
     */
    @IBAction func openGalleryButton(_ sender: Any) {
        imagepickerController.sourceType = .photoLibrary
        self.present(imagepickerController, animated: true, completion: nil)
    }
    
    ///MARK:- Image Picker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let profileImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageview.image = profileImage
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    /**
     Resizing the profile picture for displaying purpose
     - Parameters:
        - image: Which image do we need to resize
        - newWidth: How much width do we need the image size
     */
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let newHeight = CGFloat(150.0)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    /**
     Random generation with the given length of digits
     - Parameters:
        - digits: It will generate the number with the given digits
     */
    func randomNumberWith(digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
    /**
     Register button action checks if all the mandatory fields have been entered and if it has then will register user with the doctor and also give a Universal Identifier Number to the user.
     */
    @IBAction func registerButton(_ sender: Any) {
        var uhiNumber = 0
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "PatientsContactInfo",
                                       in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        if (firstname.text != "" && lastname.text != "" && maidenname.text != "" && dateofbirth.text != "" && email.text != "" && displayname.text != "" && address1.text != "" && state.text != "" && country.text != "" && postcode.text != "" && mobilenumber.text != "" && emercontactname.text != "" && emercontactnumber.text != "" && emercontactemail.text != "" && emercontactrelationship.text != "" && pinnumber.text != "" && username.text != "" && password.text != "" && reenterpassword.text != "" && (password.text == reenterpassword.text)){
            
            if (password.text != reenterpassword.text){
                let alert = UIAlertController(title: "Not Valid", message: "Password you have entered didnt match with the Re-enter password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
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
                person.setValue(2, forKey: "accessLevel")
                
                
                uhiNumber = randomNumberWith(digits: 5)
                print(uhiNumber)
                //For QR Code
                let data = "\(uhiNumber)".data(using: String.Encoding.ascii)
                guard let qr = CIFilter(name: "CIQRCodeGenerator") else { return }
                qr.setValue(data, forKey: "inputMessage")
                guard let qrImg = qr.outputImage else { return }
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImg.transformed(by: transform)
                print(scaledQrImage)
                let QR = convertCIImage(cmage: scaledQrImage)
                person.setValue(QR.pngData() as NSData?, forKey: "qrCode")
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
            ///Alert for missing required fields
            let alert = UIAlertController(title: "Not Valid", message: "Please enter all the mandatory fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        do {
            try managedContext.save()
            patients.append(person)
            let alert = UIAlertController(title: "Successful", message: "You have successfully registred and your UHI number is: \(uhiNumber)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    /**
     Checking if the entered email address is valid or not by using Regular expression
     - Parameters:
        - testStr: Paasing the entered string to validiate
     */
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //MARK:- Text filed delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        patientname.text = displayname.text
    }
    /**
     Convering the CIImage to UIImage
     - Parameters:
        - cmage: we will pass the CIImage which is fetched from the QRCode
     */
    func convertCIImage(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let QRimage:UIImage = UIImage.init(cgImage: cgImage)
        return QRimage
    }
}
/**
 Random number generation using the extension of Integer
 */
extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}

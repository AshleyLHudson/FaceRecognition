//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Ash on 13/08/2019.
//  Copyright © 2019 Ash. All rights reserved.
//

import UIKit
import CoreImage

// Used UInavigation & Imagepicker so that users can pick photos from thier libarary.
class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var currentText: UITextView!
    
    // Import Image accesses the users folder for images to use for the face recognition.
    @IBAction func importImage(_ sender: Any) {
        // Creating the image picker for the user to pick the image
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        // This displays the image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Function so that the user can pick the photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            // If picked the image, sends it to the image view. (using image alot of times is confusing as hek)
            currentImage.image = image
        }
        // Closes down the image picker
        self.dismiss(animated: true, completion: nil)
    }
    // A function to analyse the image picked
    func detect() -> String?
    {
        // Grab the image from the image view
        let imageUsed = CIImage(image: currentImage.image!)!
        
        // set up the detector to analyse the image
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        // specifying that we want to detect faces
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        // Tell detector where and what to analyse (can change the options to detect a smile or anything (for smile use CIDetectorSmile))
        let faces = faceDetector?.features(in: imageUsed, options: [CIDetectorSmile:true])
        
        // Check the results (stores faces in an array)
        if !faces!.isEmpty
        {
            //looping through all of the faces
            for face in faces as! [CIFaceFeature]
            {
                // process all info from faces, displays the
                let moutShowing = "\n Mouth is showing: \(face.hasMouthPosition)"
                let isSmiling = "\n Person is smiling: \(face.hasSmile)"
                var bothEyes = "\n Both eyes showing: true"
                
                // if statement to catch if both of the eyes are showing
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyes = "\n Both eyes showing: false"
                }
                // Test how suspicious the person looks
                // Start at suspiciousness level 0.
                var suspectDegree = 0
                // innitallise the array of outputs
                let array = ["Low Thret", "Medium Thret", "High Thret", "Catastrophic Thret" ]
                // Get mouth, smile and eyes (with the addition of detection of dace angle.
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyes.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                
                // Output suspiciousness level from array.
                let suspectText = "\nSuspeciousness: \(array[suspectDegree])"
                currentText.text = "\(suspectText) \n \(moutShowing) \(isSmiling) \(bothEyes)"
                return array[suspectDegree]
            }
        }
        else
        {
            currentText.text = "No faces found :("
        }
        return nil
    }
    
    
    // Get a random image when output is low thret
    func lowThret() {
       // Find the path for the plist (which allocates the images for the low thret)
       let path = Bundle.main.path(forResource: "lowthreat", ofType: "plist")
       let dict = NSDictionary(contentsOfFile: path!)
    
       let data = dict?.object(forKey: "Images") as! [String]
        
       // Use the image view from main.storyboard and add the randomised image (seen here as random element)
       imageView.image = UIImage(named: data.randomElement()!)
    }
    
    // Get a random image when output is medium thret
    func mediumThret() {
        // Find the path for the plist (which allocate the images for medium thret)
        let path = Bundle.main.path(forResource: "mediumthreat", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        let data = dict?.object(forKey: "Images") as! [String]
        
        //Use the image view from main.storyboard and add the randomised image (seen here as random element)
        imageView.image = UIImage(named: data.randomElement()!)
    }
    
    // Get a random image when output is high thret
    func highThret() {
        // Find the path for the plist (which allocate the images for high thret)
        let path = Bundle.main.path(forResource: "highthreat", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        let data = dict?.object(forKey: "Images") as! [String]
        
        //Use the image view from main.storyboard and add the randomised image (seen here as random element)
        imageView.image = UIImage(named: data.randomElement()!)
    }
    
    // Get a random image when output is catastrophic
    func catastrophicThret() {
        // Find the path for the plist (which allocate the images for catastrophic thret)
        let path = Bundle.main.path(forResource: "cthreat", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        let data = dict?.object(forKey: "Images") as! [String]
        
        //Use the image view from main.storyboard and add the randomised image (seen here as random element)
        imageView.image = UIImage(named: data.randomElement()!)
    }
    // Main function to catch all threats (loading functions) in addition to 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call detect function to check if the text detected is either "Low threat, medium threat, high threat or catastrophic threat".
        let threat = detect()
        switch threat {
        case "Low Thret":
            lowThret()
        case "Medium Thret":
            mediumThret()
        case "High Thret":
            highThret()
        case "Catastrophic Thret":
            catastrophicThret()
        default:
            print("no faces found")
        }
    }


}


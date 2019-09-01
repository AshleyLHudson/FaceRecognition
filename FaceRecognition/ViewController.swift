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
        detect()
        // Closes down the image picker
        self.dismiss(animated: true, completion: nil)
    }
    // A function to analyse the image picked
    func detect()
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
                var bothEyes = "\n Both eyes showing: True"
                
                // if statement to catch if both of the eyes are showing
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyes = "\n Both eyes showing: False"
                }
                // (for fun) test how suspicious the person looks
                var suspectDegree = 0
                var array = ["Low Thret", "Medium Thret", "High Thret", "Catastrophic Thret" ]
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyes.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                let suspectText = "\nSuspeciousness: \(array[suspectDegree])"
                
                currentText.text = "\(suspectText) \n\(moutShowing) \(isSmiling) \(bothEyes)"
            }
        }
        else
        {
            currentText.text = "No faces found :("
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detect()
        
        // Do any additional setup after loading the view.
    }


}


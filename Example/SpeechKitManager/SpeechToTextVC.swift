/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The primary view controller. The speach-to-text engine is managed an configured here.
*/

import UIKit
import SpeechKitManager

public class SpeechToTextVC: UIViewController {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton : UIButton!
    private var speechKitManager:SpeechKitManager?
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Disable the record buttons until authorization has been granted.
//        recordButton.isEnabled = false
        speechKitManager = SpeechKitManager()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechKitManager?.requestSpeechRecognizerAuth({ authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("requestSpeechRecognizerAuth authorized")
                case .denied:
                    print("requestSpeechRecognizerAuth denied")
                case .restricted:
                    print("requestSpeechRecognizerAuth restricted")
                case .notDetermined:
                    print("requestSpeechRecognizerAuth notDetermined")
                }
            }
        })
    }
   
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        authorizeMicAccess()
    }
    
    fileprivate func authorizeMicAccess(){
        speechKitManager?.requestMicAuth({ (granted) in
            if granted{
                //Mic access granted start recognition
                self.recognize()
            }else{
                debugPrint("Microphone permission required")
            }
        })
    }
    
    fileprivate func recognize(){
        speechKitManager?.record(resultHandler: { (result, error) in
            var isFinal = false
            
            if let result = result {
                //User speech will fall here to text
                debugPrint(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.speechKitManager?.stop()
            }
        })
    }
}

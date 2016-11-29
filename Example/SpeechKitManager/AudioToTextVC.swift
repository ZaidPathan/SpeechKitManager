//
//  AudioToTextVC.swift
//  SpeakToMe
//
//  Created by zaid.pathan on 25/11/16.
//  Copyright © 2016 Henry Mason. All rights reserved.
//

import UIKit
import SpeechKitManager

class AudioToTextVC: UIViewController {

    @IBOutlet weak var IBtxtView: UITextView!
    let audioPath = Bundle.main.path(forResource: "testAudio", ofType: "m4a")
    var audioURL:URL?
    fileprivate var speechKitManager:SpeechKitManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechKitManager = SpeechKitManager()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func IBActionPlayAudio(_ sender: AnyObject) {
        do{
            if let audioPath = audioPath{
                audioURL = URL(fileURLWithPath: audioPath)
                if let audioURL = audioURL{
                    try speechKitManager?.playAudio(atURL: audioURL)
                }else{
                    debugPrint("No URL found")
                }
            }else{
                debugPrint("No path found")
            }
        }catch{
            print(error)
        }
    }
    
    @IBAction func IBActionAudioToText(_ sender: AnyObject) {
        speechKitManager?.requestSpeechRecognizerAuth { (authStatus) in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    if let path = self.audioPath{
                        self.speechKitManager?.recognizeAudio(atURL: URL(fileURLWithPath: path), resultHandler: { (result, error) in
                            if let result = result{
                                self.IBtxtView.text = result.bestTranscription.formattedString
                            }else if let error = error{
                                debugPrint(error.localizedDescription)
                            }
                        })
                    }else{
                        
                    }
                    
                    print("requestSpeechRecognizerAuth authorized")
                    break
                case .denied:
                    print("requestSpeechRecognizerAuth denied")
                    break
                case .restricted:
                    print("requestSpeechRecognizerAuth restricted")
                    break
                case .notDetermined:
                    print("requestSpeechRecognizerAuth notDetermined")
                    break
                }
            }
            
        }
    }
    
    
    @IBAction func IBActionStopAudio(_ sender: AnyObject) {
        speechKitManager?.stopAudio()
    }
    
    @IBAction func IBActionTitle(_ sender: AnyObject) {
        view.endEditing(true)
    }
}

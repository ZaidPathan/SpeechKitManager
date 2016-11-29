# SpeechKitManager

[![CI Status](http://img.shields.io/travis/Zaid/SpeechKitManager.svg?style=flat)](https://travis-ci.org/Zaid/SpeechKitManager)
[![Version](https://img.shields.io/cocoapods/v/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)
[![License](https://img.shields.io/cocoapods/l/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)
[![Platform](https://img.shields.io/cocoapods/p/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
XCode : 8 +

Swift : 3.0 +

iOS   : 10.0 +

Device : Real device required

## Installation

SpeechKitManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SpeechKitManager"
```
# Easy to Use
___
> Note: Add `NSSpeechRecognitionUsageDescription` and `NSMicrophoneUsageDescription`(For Speech to Text only) to `info.plist`

#### 1. Audio file to Text

    import SpeechKitManager
    
    class ViewController: UIViewController {
    
        fileprivate var skManager:SpeechKitManager?
        fileprivate let audioFilePath = Bundle.main.path(forResource: "audioFile", ofType: "m4a")
        
        override func viewDidLoad() {
            super.viewDidLoad()
    
            skManager = SpeechKitManager()
            
            //Authorize user to access speech recognition
            skManager?.requestSpeechRecognizerAuth { (authStatus) in
                /*
                 The callback may not be called on the main thread. Add an
                 operation to the main queue to update the record button's state.
                 */
                OperationQueue.main.addOperation {
                    switch authStatus {
                    case .authorized:
                        self.audioToText()
                        print("requestSpeechRecognizerAuth authorized")
                    case .denied:
                        print("requestSpeechRecognizerAuth denied")
                    case .restricted:
                        print("requestSpeechRecognizerAuth restricted")
                    case .notDetermined:
                        print("requestSpeechRecognizerAuth notDetermined")
                    }
                }
                
            }
            
        }
        
        fileprivate func audioToText(){
            if let path = audioFilePath{
                self.skManager?.recognizeAudio(atURL: URL(fileURLWithPath: path), resultHandler: { (result, error) in
                    if let result = result{
                        print(result.bestTranscription.formattedString)
                    }
                })
            }else{
                debugPrint("No path found")
            }
        }
    
    }

Optionally, you can play,pause or stop audio file.

    fileprivate func playAudio() {
            do{
                if let audioPath = audioFilePath{
                    try skManager?.playAudio(atURL: URL(fileURLWithPath: audioPath))
                }else{
                    debugPrint("No path found")
                }
            }catch{
                print(error)
            }
    }
    
    fileprivate func pauseAudio(){
        skManager?.pauseAudio()
    }
    
    fileprivate func stopAudio(){
        skManager?.stopAudio()
    }

____
#### 2. Live Speech to Text

    import SpeechKitManager
##### Step 1: Ask permission to access speech recognition to user

    fileprivate var skManager:SpeechKitManager?
        
    skManager?.requestSpeechRecognizerAuth({ authStatus in
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
        
##### Step 2: Ask permission to access microphone to user
    skManager?.requestMicAuth({ (granted) in
                if granted{
                    self.recognize()
                }else{
                    debugPrint("Microphone permission required")
                }
            })

##### Step 3: Record live audio and get speech in text format
    fileprivate func recordAudio(){
            skManager?.record(resultHandler: { (result, error) in
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
        
## Author

Zaid, zaidkhanintel@gmail.com

## License

SpeechKitManager is available under the MIT license. See the LICENSE file for more info.

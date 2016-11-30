# SpeechKitManager

[![CI Status](http://img.shields.io/travis/Zaid Pathan/SpeechKitManager.svg?style=flat)](https://travis-ci.org/Zaid Pathan/SpeechKitManager)
[![Version](https://img.shields.io/cocoapods/v/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)
[![License](https://img.shields.io/cocoapods/l/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)
[![Platform](https://img.shields.io/cocoapods/p/SpeechKitManager.svg?style=flat)](http://cocoapods.org/pods/SpeechKitManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
XCode   : 8.0 +
iOS     : 10.0 +
Swift   : 3.0 +
Device  : Real iOS device required

## Installation

SpeechKitManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SpeechKitManager"
```

## Usage

> Note : Add `NSMicrophoneUsageDescription`(For Live Speech to Text only) and `NSSpeechRecognitionUsageDescription` to `info.plist`.

##### Initialize SpeechKitManager and your audio file path and URL

```swift
fileprivate var speechKitManager:SpeechKitManager?
let audioPath = Bundle.main.path(forResource: "testAudio", ofType: "m4a")   //For audio file to text
var audioURL:URL?                                                           //For audio file to text

override func viewDidLoad() {
    super.viewDidLoad()
    speechKitManager = SpeechKitManager()
}
```

##### Authorize Speech Recognition and handle it.

```swift
speechKitManager?.requestSpeechRecognizerAuth { (authStatus) in
    /*
    The callback may not be called on the main thread. Add an
    operation to the main queue to update the record button's state.
    */
    OperationQueue.main.addOperation {
        switch authStatus {
            case .authorized:
                self.recognizeAudio()
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
```

#### 1. Audio file to Text

##### Recognize Audio

```swift
fileprivate func recognizeAudio(){
    if let path = self.audioPath{
        self.speechKitManager?.recognizeAudio(atURL: URL(fileURLWithPath: path), resultHandler: { (result, error) in
            if let result = result{
                //Audio to Text fall here
                debugPrint(result.bestTranscription.formattedString)
            }else if let error = error{
                debugPrint(error.localizedDescription)
            }
        })
    }else{
        debugPrint("no path found")
    }
}
```


#### 2. Live Speech to Text

##### Request Microphone access and handle it.

```swift
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
```

##### Recognize live speech. 📢

```swift
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
```

Awesome 🙌, look as the demo project - everything explained here is implemented in that.

## Author

Zaid Pathan, Zaidkhanintel@gmail.com

## License

SpeechKitManager is available under the MIT license. See the LICENSE file for more info.

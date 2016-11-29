//
//  SpeechKitManager.swift
//  Created by zaid.pathan on 25/11/16.
//

import Foundation
import Speech

public protocol SpeechKitManagerDelegate{
    // Called when the availability of the given recognizer changes
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool)
}

private struct SpeechKitManagerErrors {
    static let recognitionBufferRequestNil = NSError(domain: "recognitionBufferRequest not found", code: 1000, userInfo: nil)
    static let recognitionURLRequestNil = NSError(domain: "recognitionURLRequest not found", code: 1001, userInfo: nil)
}

open class SpeechKitManager:NSObject {
    open var locale = "en_US"   //Ex: for Arabic ar_SA , https://gist.github.com/jacobbubu/1836273
    
    open var delegate:SpeechKitManagerDelegate?
    
    private lazy var speechRecognizer = SFSpeechRecognizer()
    
    //For speech to text
    private var recognitionBufferRequest:SFSpeechAudioBufferRecognitionRequest?
    
    //For audio file to text
    private var recognitionURLRequest: SFSpeechURLRecognitionRequest?
    
    private var audioPlayer:AVAudioPlayer?
    
    private lazy var audioEngine = AVAudioEngine()
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    public override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: locale))
        speechRecognizer?.delegate = self
    }
    
    //MARK:- Request auth
    open func requestSpeechRecognizerAuth(_ handler: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Swift.Void){
        SFSpeechRecognizer.requestAuthorization(handler)
    }
    
    open func requestMicAuth(_ handler:@escaping (Bool)->Swift.Void){
        AVAudioSession.sharedInstance().requestRecordPermission(handler)
    }
    
    
    open func recognizeAudio(atURL:URL,resultHandler: @escaping (SFSpeechRecognitionResult?, Error?) -> Swift.Void){
        speechRecognizer?.delegate = self
        recognitionURLRequest = SFSpeechURLRecognitionRequest(url: atURL)
        
        if let recognitionURLRequest = recognitionURLRequest{
            speechRecognizer?.recognitionTask(with: recognitionURLRequest, resultHandler: resultHandler)
        }else{
            resultHandler(nil, SpeechKitManagerErrors.recognitionURLRequestNil)
        }
    }
    
    open func recogniseLiveSpeech(resultHandler: @escaping (SFSpeechRecognitionResult?, Error?) -> Swift.Void) throws{
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionBufferRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionBufferRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        if let recognitionBufferRequest = recognitionBufferRequest{
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionBufferRequest, resultHandler: resultHandler)
        }else{
            resultHandler(nil, SpeechKitManagerErrors.recognitionBufferRequestNil)
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionBufferRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
    
    open func record(resultHandler: @escaping (SFSpeechRecognitionResult?, Error?) -> Swift.Void){
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionBufferRequest?.endAudio()
        } else {
            try! recogniseLiveSpeech(resultHandler: resultHandler)
        }
    }
    
    open func stop(){
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: 0)
        
        recognitionBufferRequest = nil
        recognitionTask = nil
    }
    
    //Audio file to text
    open func playAudio(atURL:URL) throws{
        audioPlayer = try AVAudioPlayer(contentsOf:atURL)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    open func pauseAudio(){
        audioPlayer?.pause()
    }
    
    open func stopAudio(){
        audioPlayer?.stop()
    }
}


extension SpeechKitManager:SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        delegate?.speechRecognizer(speechRecognizer, availabilityDidChange: available)
    }
}

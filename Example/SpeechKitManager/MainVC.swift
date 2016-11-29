//
//  MainVC.swift
//  SpeakToMe
//
//  Created by zaid.pathan on 25/11/16.
//  Copyright © 2016 Henry Mason. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainVC{
    @IBAction func IBActionSpeechToText(_ sender: AnyObject) {
        performSegue(withIdentifier: "SpeechToTextVC", sender: nil)
    }
    
    @IBAction func IBActionAudioToText(_ sender: AnyObject) {
        performSegue(withIdentifier: "AudioToTextVC", sender: nil)
    }
}

//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Juan Carlos Guillén Castro on 5/2/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    func configureContent() {
        hideKeyboardWhenTappedAround()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            //Creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Creando una dirección para el archivo de audio
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("-------------------------AudioURL-------------------------")
            print(audioURL!)
            print("-------------------------*-------------------------")
            
            //Crear opciones para el grabador de audio
            var settings: [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabación de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if audioRecorder!.isRecording {
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el texto del botón grabar
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //Empezar a grabar
            audioRecorder?.record()
            //Cambiar el titulo del botón a detener
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let context = appDelegate!.persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text!
        sound.audio = NSData(contentsOf: audioURL!)! as Data
        appDelegate!.saveContext()
        navigationController?.popViewController(animated: true)
    }

}

//
//  ViewController.swift
//  SoundBoard
//
//  Created by Juan Carlos Guillén Castro on 5/2/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sounds: [Sound] = []
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = appDelegate!.persistentContainer.viewContext
        do {
            sounds = try! context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        }
    }
    
    func configureContent() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try! AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch {}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sound = sounds[indexPath.row]
            let context = appDelegate!.persistentContainer.viewContext
            context.delete(sound)
            appDelegate!.saveContext()
            do {
                sounds = try! context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }
}


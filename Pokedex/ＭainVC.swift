//
//  ViewController.swift
//  Pokedex
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var musicBtn: UIButton!
    
    var pokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
        initMusic()
        
    }
    
    func initMusic() {
        
        let musicPath = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let musicURL = URL(fileURLWithPath: musicPath)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            musicBtn.alpha = 0.7
        } else {
            musicPlayer.play()
            musicBtn.alpha = 1
        }
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeid = Int(row["id"]!)!
                let pokename = row["identifier"]!.capitalized
                let poke = Pokemon(pokeName: pokename, pokeID: pokeid)
                pokemons.append(poke)
            }
            
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
//            let pokemon = Pokemon(pokeName: pokemons[indexPath.row].pokeName, pokeID: pokemons[indexPath.row].pokeID)
            let pokemon = pokemons[indexPath.row]
            
            cell.configureUI(pokemon: pokemon)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemons.count
    }

}


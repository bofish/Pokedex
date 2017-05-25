//
//  ViewController.swift
//  Pokedex
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var musicBtn: UIButton!
    
    var pokemons = [Pokemon]()
    var filterPokemons = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initMusic()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            if inSearchMode {
                
                let filterPoke = filterPokemons[indexPath.row]
                cell.configureUI(pokemon: filterPoke)
            } else {
                
                let pokemon = pokemons[indexPath.row]
                cell.configureUI(pokemon: pokemon)
            }
            
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
        
        if inSearchMode {
            
            return filterPokemons.count
        } else {
            
            return pokemons.count
        }
        
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            let filter = searchBar.text!
            filterPokemons = pokemons.filter({ $0.pokeName.range(of: filter) != nil})
            collection.reloadData()
        }
    }
}


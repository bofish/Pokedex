//
//  pokemonDetailVC.swift
//  Pokedex
//
//  Created by Ben on 2017/5/25.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import UIKit
import Alamofire

class pokemonDetailVC: UIViewController {

    
    @IBOutlet weak var pokeNameLbl: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeDescriptionLbl: UILabel!
    @IBOutlet weak var pokeTypeLbl: UILabel!
    @IBOutlet weak var pokeIDLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var evoTextLbl: UILabel!
    @IBOutlet weak var currentPokeImg: UIImageView!
    @IBOutlet weak var nextEvoPokeImg: UIImageView!
    
    
    private var _pokeDetail: Pokemon!
    private var _pokeName: String!
    private var _pokeImg: String!
    private var _pokeDescription: String!
    private var _pokeType: String!
    private var _pokeID: String!
    private var _attack: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _evoText: String!
    private var _pokeLvl: String!
    private var _nextEvoPokeID: String!
    private var _nextEvoPokeName: String!
    
    var nextEvoPokeID: String {
        if _nextEvoPokeID == nil {
            _nextEvoPokeID = ""
        }
        return _nextEvoPokeID
    }
    var nextEvoPokeName: String {
        if _nextEvoPokeName == nil {
            _nextEvoPokeName = ""
        }
        return _nextEvoPokeName
    }
    var pokeLvl: String {
        if _pokeLvl == nil {
            _pokeLvl = ""
        }
        return _pokeLvl
    }
    var pokeName: String {
        if _pokeName == nil {
            _pokeName = ""
        }
        return _pokeName
    }
    var pokeDescription: String {
        if _pokeDescription == nil {
            _pokeDescription = ""
        }
        return _pokeDescription
    }
    var pokeType: String {
        if _pokeType == nil {
            _pokeType = ""
        }
        return _pokeType
    }
    var pokeID: String {
        if _pokeID == nil {
            _pokeID = ""
        }
        return _pokeID
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var evoText: String {
        if _evoText == nil {
            _evoText = ""
        }
        return _evoText
    }
    
    var pokeDetail: Pokemon {
        get {
            return _pokeDetail
        } set {
            _pokeDetail = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPokemonData {
            print("HEREEEEEE")
            print(self._attack)
            print(self._defense)
            print(self._height)
            print(self._weight)
            self.updateUI()
        }
        

    }
    
    func updateUI() {
        pokeNameLbl.text = _pokeDetail.pokeName
        pokeIDLbl.text = "\(_pokeDetail.pokeID)"
        heightLbl.text = _height
        weightLbl.text = _weight
        attackLbl.text = _attack
        defenseLbl.text = _defense
        pokeTypeLbl.text = _pokeType
        pokeDescriptionLbl.text = _pokeDescription
        
        if _nextEvoPokeID == "" {
            evoTextLbl.text = "No Evolution"
            nextEvoPokeImg.isHidden = true
            
        } else {
            evoTextLbl.text = "Next Evolution: \(_nextEvoPokeName!) -- \(_pokeLvl!)"
            nextEvoPokeImg.image = UIImage(named: nextEvoPokeID)
            nextEvoPokeImg.isHidden = false
        }
        
        
        
        
        let img = UIImage(named: "\(_pokeDetail.pokeID)")
        pokeImg.image = img
        currentPokeImg.image = img
    }

    
    func downloadPokemonData(complete: @escaping DownloadComplete) {
        
        let pokemonUrl = URL(string: "\(POKEMON_URL)\(_pokeDetail.pokeID)")!
        
        Alamofire.request(pokemonUrl).responseJSON { response in
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, Any>], types.count > 0 {
                    
                    if let typeName = types[0]["name"] as? String {
                        self._pokeType = typeName.capitalized
                        
                        if types.count > 1 {
                            
                            for x in 1..<types.count {
                                print(x)
                                let newTypeName = types[x]["name"] as! String
                                self._pokeType.append("/\(newTypeName.capitalized)")
                            }
                        }
                    }
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, Any>] {
                    
                    if let resourceURL = descriptions[0]["resource_uri"] as? String {
                        
                        let desURL = "\(BASE_URL)\(resourceURL)"
                        
                        Alamofire.request(desURL).responseJSON { response in
                         
                            if let desDict = response.result.value as? Dictionary<String, Any> {
                                
                                if let str = desDict["description"] as? String {
                                    let description = str.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._pokeDescription = description
                                }
                                
                            }
                            
                            complete()
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 {
                    
                    if let evoName = evolutions[0]["to"] as? String {
                        
                        if evoName.range(of: "mega") == nil {
                            self._nextEvoPokeName = evoName
                            
                            if let evoResource_uri = evolutions[0]["resource_uri"] as? String {
                                let new = evoResource_uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let evoID = new.replacingOccurrences(of: "/", with: "")
                                self._nextEvoPokeID = evoID
                            }
                            
                            if let method = evolutions[0]["method"] as? String {
                                
                                if method == "level_up" {
                                    
                                    if let level = evolutions[0]["level"] as? Int {
                                        self._pokeLvl = "Level \(level)"
                                    }
                                } else if method == "stone" {
                                    self._pokeLvl = "Using Stone"
                                } else if method == "trade" {
                                    self._pokeLvl = "Trade Pokemon"
                                } else {
                                    self._pokeLvl = "Unknown"
                                }
                            }
                        } else {
                            self._nextEvoPokeID = ""
                        }
                    } 
                } else {
                    self._nextEvoPokeID = ""
                }
            }
            
            complete()
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

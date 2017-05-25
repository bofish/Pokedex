//
//  pokemonDetailVC.swift
//  Pokedex
//
//  Created by Ben on 2017/5/25.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import UIKit

class pokemonDetailVC: UIViewController {

    
    @IBOutlet weak var pokeNameLbl: UILabel!
    
    private var _pokeDetail: Pokemon!
    
    var pokeDetail: Pokemon {
        get {
            return _pokeDetail
        } set {
            _pokeDetail = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokeNameLbl.text = _pokeDetail.pokeName
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

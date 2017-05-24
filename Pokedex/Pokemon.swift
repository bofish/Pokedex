//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _pokeID: Int!
    fileprivate var _pokeName: String!
    
    var pokeID: Int {
        
        return _pokeID
    }
    
    var pokeName: String {
        
        return _pokeName
    }
    
    init(pokeName: String, pokeID: Int) {
         _pokeName = pokeName
         _pokeID = pokeID
    }
    
}

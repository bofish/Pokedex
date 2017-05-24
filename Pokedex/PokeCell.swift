//
//  PokeCell.swift
//  Pokedex
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 Boyce. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    func configureUI(pokemon: Pokemon) {
        pokeName.text = pokemon.pokeName
        pokeImage.image = UIImage(named: "\(pokemon.pokeID)")
        
    }
    
}

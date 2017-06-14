//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Paul on 14/06/2017.
//  Copyright © 2017 Technicae. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name // This is where the view controller recieves the data that was passed to it
        
    }



}

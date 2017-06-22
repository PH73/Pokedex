//
//  pokemon.swift
//  pokedex3
//
//  Created by Paul on 23/05/2017.
//  Copyright © 2017 Technicae. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    // data protection - getter and setter (getters are below) - this means when you request a value from the class, if it is empty you do not get a NIL returned that will likely cause a crash, but rather, an empty string "" is returned
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
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
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
        
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"

    }

    func downloadPokemonDetail(completed: @escaping DownloadComplete) { //this links to the closure defined in constants.swift
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
           if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
            if let height = dict["height"] as? String {
                    self._height = height
            
            }
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            
            print(self._weight)
            print(self._height)
            print(self._attack)
            print(self._defense)
            
            
        }
            
        completed() //this is the part that tells the function is has completed (in the closure)
            
    }
    
}


}

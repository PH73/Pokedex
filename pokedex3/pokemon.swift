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
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    // data protection - getter and setter (getters are below) - this means when you request a value from the class, if it is empty you do not get a NIL returned that will likely cause a crash, but rather, an empty string "" is returned
    
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
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
            
            if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {  // the , denotes a 'where' condition to ensure there is at least one dictionary
                
                if let name = types[0]["name"] { //type[0] = first dictionary in the array of 'type'
                    
                    self._type = name.capitalized
                }
                
                if types.count > 1 { // this sets up a loop for where there is more than one dictionary, using x as the loop counter
                    for x in 1..<types.count {
                        if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalized)" // this unwraps the value of self._type and adds a "/" and the new name value to it for each loop
                            
                        }
                    }
                }
                
                print(self._type)
                
            } else {
                self._type = ""
            }
            
            if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                if let url = descArr[0]["resource_uri"] {
                    let descURL = "\(URL_BASE)\(url)"
                    Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                 
                        if let descDict = response.result.value as? Dictionary<String, Any> {
                            if let description = descDict["description"] as? String {
                                let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                self._description = newDescription
                                print(newDescription)
                            }
                        }
                        completed()
                })
            }
            
            } else {
                self._description = ""
            }
            
            if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 {
                if let nextEvo = evolutions[0]["to"] as? String {
                    if nextEvo.range(of: "mega") == nil { //filters any 'mega' in case they are returned, as this code is not supporting them
                        self._nextEvolutionName = nextEvo
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvolutionID = nextEvoId
                            
                            if let lvlExist = evolutions[0]["level"] {
                                if let lvl = lvlExist as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                            } else {
                                self._nextEvolutionLevel = ""
                            }
                            
                        }
                    }
                }
                print(self.nextEvolutionLevel)
                print(self.nextEvolutionName)
                print(self.nextEvolutionID)
            }
        }
            
        completed() //this is the part that tells the function is has completed (in the closure)
            
    }
    
}


}

//
//  Constants.swift
//  pokedex3
//
//  Created by Paul on 22/06/2017.
//  Copyright © 2017 Technicae. All rights reserved.
//

import Foundation
//These variables will be globally available

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () //this is a closure (or block of code that is run at a particular time) - it is used to let the viewController know when the asynchronous network load has completed (all network loads are asynchronous so you don't know when they will complete, and cannot therefore display the variables you are loading until it is complete!

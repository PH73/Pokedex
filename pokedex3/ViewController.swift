//
//  ViewController.swift
//  pokedex3
//
//  Created by Paul on 23/05/2017.
//  Copyright © 2017 Technicae. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType= UIReturnKeyType.done
        
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //loops continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        // the do line below ensures that we capture any errors that might be thrown with the CSV library
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            // loop through CSV to pull data and add to array...
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            // this is the code that executes if an error is thrown - it is required by the do function above
            print(err.debugDescription)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
//            The code below was used to build the CollectionView content without the pokemon array being created, 
//            i.e. just to get it up and running. The new code below, uses the contents of the array...
//            let pokemon = Pokemon(name: "Pokemon", pokedexId: indexPath.row)
//            cell.configureCell(pokemon) //this sets the icons for each cell
            
            //let poke = pokemon[indexPath.row]
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
                
            // cell.configureCell(poke)
                
            }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // code here executes when the cell is tapped
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count //number of Pokemon in the array
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2 // this sets the transparency of the button based upon the music being played or paused
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Removes the keyboard after the search button is pressed
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // The || below mean OR
        if searchBar.text == nil || searchBar.text == "" {
         
            inSearchMode = false
            collection.reloadData() // this ensures that the original list is reloaded if the search bar is empty of emptied
            
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            // In the code below, the $0 refers to the origina list of items
            // so, the code is filtering the list of original items by those that match the 'lower' constant
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            // the code below reloads the collection view with the new data from the filtered list
            collection.reloadData()
        }
        
    }
    
}




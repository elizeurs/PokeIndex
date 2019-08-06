//
//  PokeTestController.swift
//  PokeTest
//
//  Created by Elizeu RS on 31/07/19.
//  Copyright © 2019 elizeurs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PokeTestCell"

class PokeIndexController: UICollectionViewController {
  
  //  MARK: - Properties
  
  var pokemon = [Pokemon]()
  var filteredPokemon = [Pokemon]()
  var inSearchMode = false
  var searchBar: UISearchBar!
  
  //  MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewComponents()
    fetchPokemon()
    
  }
  
  //  selectors
  @objc func showSearchBar() {
    configureSearchBar()
  }
  
  //  MARK: - API
  
  func fetchPokemon() {
    Service.shared.fetchPokemon { (pokemon) in
      DispatchQueue.main.async {
        self.pokemon = pokemon
        self.collectionView.reloadData()
      }
    }
  }
  
  
  //  MARK: - Helper functions
  
  func configureSearchBar() {

      searchBar = UISearchBar()
      searchBar.delegate = self
      searchBar.sizeToFit()
      searchBar.showsCancelButton = true
      searchBar.becomeFirstResponder()
      searchBar.tintColor = .white
      
      navigationItem.rightBarButtonItem = nil
      navigationItem.titleView = searchBar
  }
  
  func configureSearchBarButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    navigationItem.rightBarButtonItem?.tintColor = .white
  }
  
  func configureViewComponents() {
    collectionView.backgroundColor = .white
    
    navigationController?.navigationBar.barTintColor = .mainGray()
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isTranslucent = false
    
    navigationItem.title = "PokerTest"
    
    configureSearchBarButton()
    
    collectionView.register(PokeIndexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
}

// MARK: - UISearchBarDelegate

extension PokeIndexController: UISearchBarDelegate {
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    navigationItem.titleView = nil
    configureSearchBarButton()
    inSearchMode = false
    collectionView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText == "" || searchBar.text == nil {
      inSearchMode = false
      collectionView.reloadData()
      view.endEditing(true)
    } else {
      inSearchMode = true
      filteredPokemon = pokemon.filter({ $0.name?.range(of: searchText.lowercased()) != nil })
      collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDataSource/Delegate

extension PokeIndexController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return inSearchMode ? filteredPokemon.count : pokemon.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokeIndexCell
    
    cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PokeIndexController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = (view.frame.width - 36) / 3
    return CGSize(width: width, height: width)
    
  }
}

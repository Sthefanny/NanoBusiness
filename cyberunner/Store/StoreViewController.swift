//
//  StoreViewController.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 22/02/22.
//

import Foundation
import UIKit

class StoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let userData = UserData()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnZoey: UIButton!
    @IBOutlet weak var btnChris: UIButton!
    
    @IBOutlet weak var cardsCollection: UICollectionView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCollection.layer.cornerRadius = 32
        cardsCollection.delegate = self
        cardsCollection.dataSource = self
        



        
//        titleLabel.font = UIFont(name: "NicoMoji-Regular", size: 21)
//        titleLabel.minimumScaleFactor = 0.01
//        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func BtnZoeyPressed(_ sender: Any) {
        userData.setCharacter(char: .zoey)
        closeView()
    }
    
    @IBAction func BtnChrisPressed(_ sender: Any) {
        userData.setCharacter(char: .chris)
        closeView()
    }
    
    func closeView() {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeroesList.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hero = HeroesList.all[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCard", for: indexPath) as! HeroCardCollectionViewCell
        
        cell.imageHero.image = hero.image
        cell.nameHero.text = hero.name
        cell.priceHero.text = hero.price.description
        
        if hero.locked {
            cell.lockHero.alpha = 0.6
            cell.imageHero.alpha = 0.2
            cell.priceHero.text = "?"
            cell.nameHero.textColor = UIColor.gray
            cell.priceHero.textColor = UIColor.gray
            cell.nameHero
                .text = "?"
            cell.coinSymbol.alpha = 0
            cell.buttonInfo.alpha = 1
            cell.baseStore.image = UIImage(named: "baseStoreNill")
        }
        // tentar a condicional
        return cell
    }
}

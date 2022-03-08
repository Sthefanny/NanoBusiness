//
//  HeroCardCollectionViewCell.swift
//  cyberunner
//
//  Created by Ana C S Costa on 25/02/22.
//

import UIKit

class HeroCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var baseStore: UIImageView!
    
    @IBOutlet weak var imageHero: UIImageView!
    
    @IBOutlet weak var priceHero: UILabel!
    @IBOutlet weak var nameHero: UILabel!
    
    @IBOutlet weak var lockHero: UIImageView!
    @IBOutlet weak var coinSymbol: UIImageView!
    @IBOutlet weak var buttonInfo: UIButton!
    
    @IBOutlet weak var infoView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceHero.font = UIFont(name: "NicoMoji-Regular", size: 17)
        priceHero.minimumScaleFactor = 0.01
        priceHero.adjustsFontSizeToFitWidth = true
        
        nameHero.font = UIFont(name: "NicoMoji-Regular", size: 20)
        nameHero.minimumScaleFactor = 0.01
        nameHero.adjustsFontSizeToFitWidth = true
        
        infoView.layer.cornerRadius = 16

//        infoView.layer.cornerRadius = infoView.frame.size.height/2.0

        infoView.layer.masksToBounds = true
    
    
    }
    @IBAction func buttonCellHeroTap(_ sender: Any) {
        
        
//        let hero = HeroesList.all
    
//        if hero.locked == false {
        baseStore.image = UIImage(named: "baseStoreSelected")
        nameHero.text = "BUY"
        priceHero.textColor = UIColor(named: "appRed")
        coinSymbol.tintColor = UIColor(named: "appRed")
//        }
        
    }
    
    @IBAction func infoTap(_ sender: Any) {
        infoView.alpha = 1
        lockHero.alpha = 0
        buttonInfo.tintColor = .white
    }
    
}

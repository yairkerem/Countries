//
//  FlagViewController.swift
//  Countries
//
//  Created by Yair Kerem on 21/06/2022.
//

import UIKit

protocol FlagViewControllerDelegate {
    func toggledIsVisited(sender: Country)
}

class FlagViewController: UIViewController {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryPopulationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    
    @IBAction func countryIsVisitedTapped(_ sender: UISwitch) {
        country?.isVisited.toggle()
        if let country = country {
            delegate?.toggledIsVisited(sender: country)
        }
    }
    
    @IBOutlet weak var countryIsVisitedTapped: UISwitch!
    
    var delegate: FlagViewControllerDelegate? = nil

    var country: Country? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let country = country {
            super.title = country.name
            
            if country.isVisited {
                countryIsVisitedTapped.isOn = true
            } else {
                countryIsVisitedTapped.isOn = false
            }
            
            
            let population = NumberFormatter()
            population.numberStyle = .decimal
            let formattedPopulation = population.string(from: NSNumber(value: country.population))
            self.countryPopulationLabel.text = formattedPopulation
            
            flagImageView.image = UIImage(named: country.imageName)
            self.continentLabel.text = country.continent.rawValue
        }
    }
}



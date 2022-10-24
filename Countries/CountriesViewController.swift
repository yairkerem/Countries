//
//  CountriesViewController.swift
//  Countries
//
//  Created by Yair Kerem on 07/06/2022.
//

import UIKit

class CountriesViewController: UIViewController {
    
    var countryList = [
        Country(name: "Argentina", population: 45_000_000, imageName: "ar", continent: .america, isVisited: true),
        Country(name: "Austria", population: 9_000_000, imageName: "at", continent: .europe, isVisited: false),
        Country(name: "Denmark", population: 6_000_000, imageName: "dk", continent: .europe, isVisited: false),
        Country(name: "Finland", population: 5_500_000, imageName: "fi", continent: .europe, isVisited: false),
        Country(name: "Scotland", population: 5_500_000, imageName: "gb-sct", continent: .europe, isVisited: true),
        Country(name: "South Korea", population: 52_000_000, imageName: "kr", continent: .asia, isVisited: false),
        Country(name: "Netherlands", population: 17_000_000, imageName: "nl", continent: .europe, isVisited: true),
        Country(name: "Peru", population: 33_000_000, imageName: "pe", continent: .america, isVisited: true),
        Country(name: "Rwanda", population: 13_000_000, imageName: "rw", continent: .africa, isVisited: false),
        Country(name: "Senegal", population: 16_000_000, imageName: "sn", continent: .africa, isVisited: false),
        Country(name: "Uruguay", population: 3_500_000, imageName: "uy", continent: .america, isVisited: false),
        Country(name: "South Africa", population: 59_000_000, imageName: "za", continent: .africa, isVisited: true),
    ]
    var countriesToShow: [Country] = []
    var visitedCountries: [String] = []
    
    
    @IBOutlet weak var countryCollectionView: UICollectionView!
    @IBOutlet weak var continentSegmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            countriesToShow = countryList
        case 1:
            countriesToShow = countryList.filter{ $0.continent == .europe}
        case 2:
            countriesToShow = countryList.filter{ $0.continent == .america}
            
        default:
            countriesToShow = countryList
        }
        countryCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        
//      visitStatusInit()
        restoreVisitStatus()
        
        super.viewDidLoad()
        countriesToShow = countryList
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self
        
    }
    
    func visitStatusInit() {
        countryList.forEach {country in
            if country.isVisited {
                visitedCountries.append(country.name)
            }
        }
        UserDefaults.standard.set(visitedCountries, forKey: "visitedCountries")
    }
    
    func restoreVisitStatus() {
        guard let visitList = UserDefaults.standard.stringArray(forKey: "visitedCountries") else {
            return
        }
        self.visitedCountries = visitList
        for (index, country) in countryList .enumerated(){
            if self.visitedCountries.contains(country.name) {
                countryList[index].isVisited = true
            } else {
                countryList[index].isVisited = false
            }
        }
    }
}

extension CountriesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countriesToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCellId", for: indexPath) as! CountryCollectionViewCell
        
        let country = countriesToShow[indexPath.row]
        
        countryCell.countryNameLabel.text = country.name
        countryCell.flagImageView.image = UIImage(named: country.imageName)
        countryCell.continentLabel.text = country.continent.rawValue
        
        let population = NumberFormatter()
        population.numberStyle = .decimal
        guard let formattedPopulation = population.string(from: NSNumber(value: country.population)) else {
            return countryCell
        }
        countryCell.countryPopulationLabel.text = String(formattedPopulation)
        countryCell.country = country
        
        if country.isVisited {
            countryCell.isVisitedImageView.image = UIImage(named: "read")
        } else {
            countryCell.isVisitedImageView.image = UIImage(named: "unread")
            
        }
        return countryCell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCollectionViewCell
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0
        //        self.performSegue(withIdentifier: "SegueToShowFlag", sender: nil)  // this will be used once the storyboard segue is removed
    }
    
}

class CountryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var isVisitedImageView: UIImageView!
    
    @IBOutlet weak var countryPopulationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    
    var country: Country? = nil
}


extension CountriesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToShowFlag" {
            if let destination = segue.destination as? FlagViewController,
               let selectedCell = sender as? CountryCollectionViewCell {
                destination.country = selectedCell.country
                destination.delegate = self
            }
        }
    }
}



extension CountriesViewController: UICollectionViewDelegate, FlagViewControllerDelegate {
    func toggledIsVisited(sender: Country) {
        
        for (index, country) in countryList .enumerated(){
            if country.name == sender.name {
                countryList[index].isVisited = sender.isVisited
                
                if self.visitedCountries.contains(country.name) && sender.isVisited == false{
                    if let index = self.visitedCountries.firstIndex(of: country.name) {
                        self.visitedCountries.remove(at: index)
                    }
                } else {
                    if self.visitedCountries.contains(country.name) == false && sender.isVisited == true{
                        self.visitedCountries.append(country.name)
                    }
                }
            }
        }
        
        countriesToShow = countryList
        countryCollectionView.reloadData()
        UserDefaults.standard.set(self.visitedCountries, forKey: "visitedCountries")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        return CGSize(width: width, height: width + 100)
    }
    
}




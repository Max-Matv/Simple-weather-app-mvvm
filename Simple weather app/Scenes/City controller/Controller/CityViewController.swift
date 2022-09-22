//
//  CityViewController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 02.Jul.22.
//

import UIKit
import CoreLocation

protocol CityViewControllerProtocol: AnyObject {
    
}

class CityViewController: UIViewController {

    
    @IBOutlet weak var someView: UIView!
    @IBOutlet weak private var currentCityLocalizable: UILabel!
    @IBOutlet weak private var openLabel: UILabel!
    @IBOutlet weak private var currentCityContainer: UIView!
    @IBOutlet weak private var currentCityLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    var viewModel: CityViewModelProtocol?
    private let searchController = UISearchController(searchResultsController: nil)
    private let locationManager = CLLocationManager()
    private var coordinates: CLLocationCoordinate2D?
    private var isCoordinatesDetermined: Bool = false
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setCurrentLocation()
        tableView.dataSource = self
        tableView.delegate = self
        setupSearchController()
        definesPresentationContext = true
        setupTransitionToDebugScreen()
        setupCurrentCityContainer()
        setupLocalization()
    }
    
    private func setupTransitionToDebugScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 10
        someView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapAction(_ sender: UITapGestureRecognizer) {
        let vc = DebugScreenController.instantiate() as! DebugScreenController
        vc.viewModel = DebugViewModel(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLocalization() {
        openLabel.text = "Open Label".localized()
        currentCityLocalizable.text = "Current City Localizable".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCurrentLocation()
    }
    
    private func setupCurrentCityContainer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectCurrentCity))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        currentCityContainer.addGestureRecognizer(tap)
    }

    @objc
    private func selectCurrentCity(_ sender: UITapGestureRecognizer) {
        if isCoordinatesDetermined {
            let vc = WeatherInfoController.instantiate() as! WeatherInfoController
            vc.city = (viewModel?.getCurrentCity())!
            vc.viewModel = WeatherInfoViewModel(viewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 1000
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City"
        navigationItem.searchController = searchController
    }
    
}

extension CityViewController: CityViewControllerProtocol {
    
}

extension CityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else { return }
        guard let city = viewModel?.searchCurrentLocation(lat: coordinates.latitude, lon: coordinates.longitude) else { return }
        viewModel?.setCurrentCity(city)
        currentCityLabel.text? = city.city
        isCoordinatesDetermined = true
        currentCityContainer.backgroundColor = .green
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        if status != .notDetermined,
           status != .denied,
           status != .restricted {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension CityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel?.getFilteredCity().count ?? 0
        }
        return viewModel?.getCityList().count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") as? CityTableViewCell else {
            fatalError()
        }
        var city: City
        if isFiltering {
            city = (viewModel?.getFilteredCity()[indexPath.row])!
        } else {
            city = (viewModel?.getCityList()[indexPath.row])!
        }
        cell.setupCell(city: city)
        cell.buttonPressed = {
            self.viewModel?.updateCity(city: city)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WeatherInfoController.instantiate() as! WeatherInfoController
        var city: City
        if isFiltering {
            city = (viewModel?.getFilteredCity()[indexPath.row])!
        } else {
            city = (viewModel?.getCityList()[indexPath.row])!
        }
        vc.city = city
        vc.viewModel = WeatherInfoViewModel(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filteredContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

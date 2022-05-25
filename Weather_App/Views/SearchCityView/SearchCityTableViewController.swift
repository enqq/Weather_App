//
//  SearchCityTableViewController.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 18/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchCityTableViewController: UITableViewController {

    //MARK: - Dependencies
    private var viewModel: SearchCityViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: - Outlets
    @IBOutlet var citiesTableView: UITableView!
    @IBOutlet weak var textSearchBar: UISearchBar!
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        textSearchBar.becomeFirstResponder()
        registerCell()
        
        initViewModel()
        bindToViewModel()
        bindTableView()
    }
    
    //MARK: - Bind to ViewModel
    private func initViewModel(){
        viewModel = SearchCityViewModel(apiServices: ApiServices(), userDefaultsHelper: UserDefaultsHelper())
    }
    
    private func bindToViewModel() {
        
        textSearchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
    }
    
    //MARK: - UITableView and register cell
    private func bindTableView(){
        
        viewModel.foundCities
            .map({$0.cities})
            .bind(to: citiesTableView.rx.items(cellIdentifier: "cityCell", cellType: CityTableViewCell.self)){ (index, city, cell) in
            cell.country.text = city.country
            cell.cityName.text = city.name
            cell.state.text = city.state
        }.disposed(by: disposeBag)
        
        citiesTableView.rx
            .modelSelected(CityModel.self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] item in
                    saveCity(item)
            }).disposed(by: disposeBag)
    }
    
    private func registerCell(){
        self.citiesTableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        citiesTableView.dataSource = nil
    }
    
    //MARK: - Functions
    private func saveCity(_ city: CityModel ) {
        viewModel.SaveCity(cityName: city.name, lat: Int(city.lat), lon: Int(city.lon))
        self.navigationController?.popToRootViewController(animated: true)
    }
}

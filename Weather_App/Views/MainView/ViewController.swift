//
//  ViewController.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 10/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    //MARK: Dependencies
    private var viewModel: MainViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: - Outlets
    @IBOutlet weak var currentCityPageControl: UIPageControl!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //MARK: - Lifecycles
    private var backgroundForComponent: UIVisualEffectView {
        
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.layer.masksToBounds = true
            return blurEffectView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        setupView()
        registerCell()
        
        initViewModel()
        bindToViewModel()
        bindDataToTableView()
    }
    
    //MARK: - Setup Background and Components
    private func setupView(){
        setBackgroundBounds()
        setBackgroundForComponents()
        setBarButtomItem()
    }
    
    private func setBackgroundBounds() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: "clean_sky")!
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func setBackgroundForComponents() {
        dailyForecastTableView.backgroundView = backgroundForComponent
        forecastCollectionView.backgroundView = backgroundForComponent
    }
    
    private func setBarButtomItem() {
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "+", style: .done, target: self, action: nil), animated: true)
        
        self.navigationItem.rightBarButtonItem!
            .rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityVC") as! SearchCityTableViewController
            self.show(nextVC, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Bind to ViewModel
    private func initViewModel(){
        viewModel = MainViewModel(apiServices: ApiServices(), userDefaultsHelper: UserDefaultsHelper())
    }
    
    private func bindToViewModel(){
        
        viewModel.totalNumbersOfCities
            .bind(to: currentCityPageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        viewModel.cityName
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cityName
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] text in
                if text.count == 0 {
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityVC") as! SearchCityTableViewController
                    show(nextVC, sender: nil)
                }
            }).disposed(by: disposeBag)
                
        viewModel.temperature
            .map({ String($0).temperature() })
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
    
        currentCityPageControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] item in
                print("Current page \(item)")
            let page = currentCityPageControl.currentPage + 1
            viewModel.currentPage.onNext(page)
        }).disposed(by: disposeBag)

    }
    
    //MARK: - UITableView and register cell
    private func bindDataToTableView() {
        
        viewModel.hourlyForecast
            .bind(to: forecastCollectionView.rx.items(cellIdentifier: "hourlyCell", cellType: ForecastCollectionViewCell.self)){ (index, item, cell) in
                cell.temperatureLabel.text = String(item.temp).temperature()
            cell.hourLabel.text = item.dt.formatted(.dateTime.hour())
            cell.iconImageView.image = UIImage(named: item.icon)
        }.disposed(by: disposeBag)
        
        viewModel.dailyForecast
            .bind(to: dailyForecastTableView.rx.items(cellIdentifier: "dailyCell", cellType: ForecastTableViewCell.self)){ (index, item, cell) in
            cell.dayLabel.text = item.dateFormatter(format: "EEEE")
            cell.iconImageView.image = UIImage(named: item.icon)
                cell.nightTemp.text = String(item.temp.night).temperature()
                cell.dayTemp.text = String(item.temp.day).temperature()
        }.disposed(by: disposeBag)
        
    }
    
    
    private func registerCell(){
        
        self.forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hourlyCell")
        
        self.dailyForecastTableView.register(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "dailyCell")
    }
}


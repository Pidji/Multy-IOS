//
//  CommonChartsViewController.swift
//  Multy
//
//  Created by Artyom Alekseev on 13.06.2018.
//  Copyright © 2018 Idealnaya rabota. All rights reserved.
//

import UIKit
import Charts

typealias ChartViewDelegateExtension = CommonChartsViewController
typealias CurrenciesCollectionViewExtension = CommonChartsViewController

class CommonChartsViewController: UIViewController {
    let presenter = CommonChartsPresenter()
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var currenciesCollectionView: UICollectionView!
    @IBOutlet weak var ratesRangeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chartDataLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.vc = self
        chartView.delegate = self
        
        let currencyRateCollectionCell = UINib.init(nibName: "CurrencyRateCollectionViewCell", bundle: nil)
        currenciesCollectionView.register(currencyRateCollectionCell, forCellWithReuseIdentifier: "CurrencyRateCollectionCellReuseIdentifier")
        
        presenter.vcViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.vcViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.vcViewDidAppear()
    }
    
    func configureChart() {
        chartView.chartDescription?.enabled = false
        chartView.dragYEnabled = false
        chartView.dragXEnabled = true
        chartView.setScaleEnabled(false)
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.backgroundColor = .clear
        chartView.autoScaleMinMaxEnabled = true
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 9.0)!
        xAxis.labelTextColor = .white
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 3
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.enabled = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 9.0)!
        rightAxis.labelTextColor = .white
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = true
        rightAxis.drawGridLinesEnabled = true
        rightAxis.gridLineDashLengths = [5]
        rightAxis.gridColor = .white
        rightAxis.drawZeroLineEnabled = true
    }
    
    func updateCurrenciesUI() {
        currenciesCollectionView.reloadData()
    }
    
    func redrawChart() {
        var chartDataEntries = [ChartDataEntry]()
        for data in presenter.chartData {
            chartDataEntries.append(ChartDataEntry(x: data.ts, y: data.value))
        }
        
        var dataSet : LineChartDataSet
        if chartView.data != nil && chartView.data!.dataSetCount > 0 {
            dataSet = chartView.data!.dataSets[0] as! LineChartDataSet
            dataSet.values = chartDataEntries
            
            chartView.data!.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            dataSet = LineChartDataSet(values: chartDataEntries, label: nil)
            dataSet.mode = .cubicBezier
            dataSet.axisDependency = .left
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            dataSet.highlightLineWidth = 2
            dataSet.highlightColor = .white
            dataSet.drawValuesEnabled = false
            dataSet.drawFilledEnabled = true
            dataSet.setColor(.white)
            dataSet.drawCirclesEnabled = false
            dataSet.lineWidth = 1.5
            dataSet.fillAlpha = 0.3
            dataSet.fillColor = .white
            
            let dataSets = [dataSet]
            let data = LineChartData(dataSets: dataSets)
            
            chartView.data = data
        }
        
        chartView.animate(yAxisDuration: 0.3)
    }
    
    func showChartDataLoader() {
        chartDataLoader.isHidden = false
        chartDataLoader.startAnimating()
    }
    
    func hideChartDataLoader() {
        chartDataLoader.stopAnimating()
        chartDataLoader.isHidden = true
    }
    
    //MARK: Actions
    @IBAction func ratesRangeSegmentedControlValueChanged(_ sender: Any) {
        presenter.didChangeRatesRange()
    }

    @IBAction func closeAction(_ sender: Any) {
        presenter.didTapClose()
    }
}

extension ChartViewDelegateExtension: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = chartView.data!.dataSets[highlight.dataSetIndex].entryIndex(entry: entry)
        presenter.didSelectChartValue(index)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        presenter.didSelectChartValue(nil)
    }
}

extension CurrenciesCollectionViewExtension: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyRateCollectionCellReuseIdentifier", for: indexPath) as! CurrencyRateCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currency = presenter.currencies[indexPath.item]
        let symbol = currency.currencyShortName
        let icon = UIImage(named: currency.currencyImgName)
        let rate = presenter.rateForCurrency(indexPath.item)
        
        var rateString = ""
        if rate != nil {
            rateString = "\(rate!.fixedFraction(digits: 2)) $"
        }
        
        let selected = indexPath.item == presenter.selectedCurrencyIndex
        
        (cell as! CurrencyRateCollectionViewCell).fill(symbol: symbol, rate: rateString, icon: icon!, selected: selected)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didChangeSelectedCurrency(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
}

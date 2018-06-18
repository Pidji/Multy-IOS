//
//  CommonChartsPresenter.swift
//  Multy
//
//  Created by Artyom Alekseev on 13.06.2018.
//  Copyright © 2018 Idealnaya rabota. All rights reserved.
//

import Foundation

enum RatesRange : Int {
    case today
    case week
    case month
    case quarter
    case halfYear
    case year
    case all
}

class Rate: NSObject {
    let currencyID: UInt32!
    let refID: UInt32!
    let ts: TimeInterval!
    let value: Double!
    
    init(currencyID: UInt32, refID: UInt32, ts: TimeInterval, value: Double) {
        self.currencyID = currencyID
        self.refID = refID
        self.ts = ts
        self.value = value
        
        super.init()
    }
}

class CommonChartsPresenter: NSObject {
    var vc : CommonChartsViewController?
    
    var selectedCurrencyIndex : Int? = 0 {
        didSet {
            if selectedCurrencyIndex != oldValue {
                vc?.redrawChart()
                vc?.updateCurrenciesUI()
            }
        }
    }
    
    var selectedRateIndex: Int? {
        didSet {
            vc?.updateCurrenciesUI()
        }
    }
    
    var currencies = DataManager.shared.allCurreniesList() {
        didSet {
            if currencies != oldValue && oldValue.count == 0 {
                selectedCurrencyIndex = 0
            }
        }
    }
    
    var currentRatesRange : RatesRange = .today {
        didSet {
            if currentRatesRange != oldValue {
                updateDataSet()
            }
        }
    }
    
    var ratesSet = [UInt32 : [Rate]]() {
        didSet {
            if ratesSet != oldValue {
                
                vc?.redrawChart()
            }
        }
    }
    
    var chartData : [Rate] {
        get {
            if selectedCurrencyIndex != nil && selectedCurrencyIndex! < currencies.count {
                let currency = currencies[selectedCurrencyIndex!]
                guard let result = ratesSet[currency.currencyBlockchain.blockchain.rawValue] else {
                    return []
                }
                
                return result
            } else {
                return []
            }
        }
    }
    
    private func updateDataSet() {
        vc?.showChartDataLoader()
        let tsFrom = tsFromForCurrentRange()
        
        //FIXME:
//        unowned let weakSelf =  self
//        DataManager.shared.apiManager.getRates(currencyIDs: [(0)], referenceID: (1), tsFrom: tsFrom, tsTo: Date().timeIntervalSince1970) { (data, error) in
//            weakSelf.vc?.hideChartDataLoader()
//
//            if data != nil {
//                let dataValues = data!["values"]
//
//            }
//        }
        vc?.hideChartDataLoader()
        ratesSet = [BLOCKCHAIN_BITCOIN.rawValue: [Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1523491200, value: 8022.51),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1523750400, value: 7921.63),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1524009600, value: 8877.08),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1524268800, value: 8968.25),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1524528000, value: 9282.12),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1524787200, value: 9407.04),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1525046400, value: 9232.19),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1525305600, value: 9845.9),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1525564800, value: 9196.13),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1525824000, value: 8421),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1526083200, value: 8672.9),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1526342400, value: 8071.04),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1526601600, value: 8533),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1526860800, value: 7505.77),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1527120000, value: 7355.06),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1527379200, value: 7474.75),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1527638400, value: 7530.55),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1527897600, value: 7503.2),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1528156800, value: 7700.11),
                                                      Rate(currencyID:BLOCKCHAIN_BITCOIN.rawValue, refID:1, ts: 1528416000, value: 6773.72)],
                        
                        BLOCKCHAIN_ETHEREUM.rawValue : [Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1523491200, value: 502.79),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1523750400, value: 503.03),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1524009600, value: 617.16),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1524268800, value: 644.13),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1524528000, value: 661.45),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1524787200, value: 689.31),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1525046400, value: 686.74),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1525305600, value: 816.58),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1525564800, value: 747.79),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1525824000, value: 677.8),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1526083200, value: 727.41),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1526342400, value: 668.38),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1526601600, value: 715.15),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1526860800, value: 577.01),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1527120000, value: 585.76),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1527379200, value: 566.59),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1527638400, value: 579.01),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1527897600, value: 591.31),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1528156800, value: 604.44),
                                                        Rate(currencyID:BLOCKCHAIN_ETHEREUM.rawValue, refID:1, ts: 1528416000, value: 524.74)]]
        
    }
    
    func rateForCurrency(_ index: Int) -> Double? {
        var result : Double?
        
        if index < currencies.count {
            let currency = currencies[index]
            let rates = ratesSet[currency.currencyBlockchain.blockchain.rawValue]
            if rates != nil && rates!.count > 0 {
                if selectedRateIndex != nil && selectedRateIndex! < rates!.count {
                    result = rates![selectedRateIndex!].value
                } else {
                    result = DataManager.shared.makeExchangeFor(blockchainType: currency.currencyBlockchain)
                }
            }
            
        }
        
        return result
    }
    
    private func tsFromForCurrentRange() -> TimeInterval? {
        var result : TimeInterval?
        
        let currentTs = Date().timeIntervalSince1970
        
        switch currentRatesRange {
        case .today:
            result = currentTs - Double(60 * 60 * 24)
            break
            
        case .week:
            result = currentTs - Double(60 * 60 * 24 * 7)
            break
            
        case .month:
            result = currentTs - Double(60 * 60 * 24 * 30)
            break
            
        case .quarter:
            result = currentTs - Double(60 * 60 * 24 * 30 * 3)
            break
            
        case .halfYear:
            result = currentTs - Double(60 * 60 * 24 * 30 * 6)
            break
            
        case .year:
            result = currentTs - Double(60 * 60 * 24 * 30 * 12)
            break
            
        case .all:
            break
            
        default: break
        }
        
        return result
    }
    
    @objc private func handleExchangeUpdatedNotification() {
        if selectedRateIndex == nil {
            vc?.updateCurrenciesUI()
        }
    }
    
    //MARK: VC events
    func vcViewDidLoad() {
        vc?.ratesRangeSegmentedControl.selectedSegmentIndex = currentRatesRange.rawValue
    }
    
    func vcViewWillAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleExchangeUpdatedNotification), name: NSNotification.Name("exchageUpdated"), object: nil)
        
        vc?.configureChart()
        updateDataSet()
    }
    
    func vcViewDidAppear() {
        
    }
    
    func didChangeRatesRange() {
        currentRatesRange = RatesRange(rawValue: vc!.ratesRangeSegmentedControl.selectedSegmentIndex)!
    }
    
    func didChangeSelectedCurrency(_ index : Int) {
        selectedCurrencyIndex = index
    }
    
    func didTapClose() {
        vc?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectChartValue(_ index: Int?) {
        selectedRateIndex = index
    }
}

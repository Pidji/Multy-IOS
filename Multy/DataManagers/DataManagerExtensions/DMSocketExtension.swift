//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension DataManager {
    func kickFromMultisigWith(wallet: UserWalletRLM, addressToKick: String, completion: @escaping(Result<Bool, String>) -> ()) {
        let payload: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.multisigWallet!.linkedWalletAddress,
            "addresstokick": addressToKick,
            "invitecode": wallet.multisigWallet!.inviteCode
        ]
        
        let params: NSDictionary = [
            "type": SocketMessageType.multisigKick.rawValue,
            "from": "",
            "to":"",
            "date": UInt64(Date().timeIntervalSince1970),
            "status": 0,
            "payload": payload
        ]
        
        
        socketManager.sendMsg(params: params) { (answerDict, err) in
            if err != nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func leaveFromMultisigWith(wallet: UserWalletRLM, completion: @escaping(Result<Bool, String>) -> ()) {
        
        let payload: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.multisigWallet!.linkedWalletAddress,
            "invitecode": wallet.multisigWallet!.inviteCode
            ]
        
        let params: NSDictionary = [
            "type": SocketMessageType.multisigLeave.rawValue,
            "from": "",
            "to":"",
            "date": UInt64(Date().timeIntervalSince1970),
            "status": 0,
            "payload": payload
        ]
        
        
        socketManager.sendMsg(params: params) { (answerDict, err) in
            if err != nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func deleteMultisigWith(wallet: UserWalletRLM, completion: @escaping(Result<Bool, String>) -> ()) {
        let payload: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.multisigWallet!.linkedWalletAddress,
            "invitecode": wallet.multisigWallet!.inviteCode
            ]
        
        let params: NSDictionary = [
            "type": SocketMessageType.multisigDelete.rawValue,
            "from": "",
            "to":"",
            "date": UInt64(Date().timeIntervalSince1970),
            "status": 0,
            "payload": payload
        ]
        
        
        socketManager.sendMsg(params: params) { (answerDict, err) in
            if err != nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func joinToMultisigWith(wallet: UserWalletRLM, inviteCode: String, completion: @escaping(Result<Bool, String>) -> ()) {
        let payloadForJoin: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.address,
            "invitecode": inviteCode,
            "addresstokick":"", //omitempty
            "walletindex": wallet.walletID,
            "currencyid": wallet.chain,
            "networkid": wallet.chainType
        ]
        
        let paramsForMsgSend: NSDictionary = [
            "type": SocketMessageType.multisigJoin.rawValue,  // it's kinda signature method eg: join:multisig.
            "from": "",              // not requied
            "to":"",                // not requied
            "date": UInt64(Date().timeIntervalSince1970), // time unix
            "status": 0,
            "payload": payloadForJoin
        ]
        
        socketManager.sendMsg(params: paramsForMsgSend) { (answerDict, err) in
            
            if answerDict == nil {
                
                print("Join to MultiSig error: \(err!)")
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                print("Join to MultiSig answer: \(answerDict!)")
                completion(Result.success(true))
            }
        }
    }
    
    func validateInviteCode(code: String, completion: @escaping(Result<NSDictionary, String>) -> ()) {
        let payloadForValidate: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "invitecode": code
        ]
        
        let paramsForMsgSend: NSDictionary = [
            "type": SocketMessageType.multisigCheck.rawValue,  // it's kinda signature method eg: join:multisig.
            "from": "",              // not requied
            "to":"",                // not requied
            "date": UInt64(Date().timeIntervalSince1970), // time unix
            "status": 0,
            "payload": payloadForValidate
        ]
        
        
        socketManager.sendMsg(params: paramsForMsgSend) { (answerDict, err) in
            if err != nil || answerDict == nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                let payloadDict = answerDict!["payload"] as! NSDictionary
                completion(Result.success(payloadDict))
            }
        }
    }
    
    func declineMultiSigTx(wallet: UserWalletRLM, histObj: HistoryRLM, completion: @escaping(Result<String, String>) -> ()) {
        let owner = wallet.multisigWallet?.currentOwner
        
        let payloadForDecline: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.multisigWallet!.linkedWalletAddress,
            "invitecode": wallet.multisigWallet!.inviteCode,
            "walletindex": owner!.walletIndex,
            "currencyid" : wallet.chain.intValue,
            "networkid"  : wallet.chainType.intValue,
            "txid": histObj.txHash
        ]
        
        let paramsForMsgSend: NSDictionary = [
            "type": SocketMessageType.multisigDecline.rawValue,
            "from": "",              // not requied
            "to":"",                // not requied
            "date": UInt64(Date().timeIntervalSince1970), // time unix
            "status": 0,
            "payload": payloadForDecline
        ]
        
        
        socketManager.sendMsg(params: paramsForMsgSend) { (answerDict, err) in
            if err != nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                let payloadDict = answerDict!["payload"] as! String
                if payloadDict == "declined" {
                    completion(Result.success(payloadDict))
                } else {
                    completion(Result.failure("wrong data"))
                }
            }
        }
    }
    
    func viewMultiSigTx(wallet: UserWalletRLM, histObj: HistoryRLM, completion: @escaping(Result<String, String>) -> ()) {
        let owner = wallet.multisigWallet?.currentOwner
        
        let payloadForView: NSDictionary = [
            "userid": DataManager.shared.apiManager.userID,
            "address": wallet.multisigWallet!.linkedWalletAddress,
            "invitecode": wallet.multisigWallet!.inviteCode,
            "walletindex": owner!.walletIndex,
            "currencyid" : wallet.chain.intValue,
            "networkid"  : wallet.chainType.intValue,
            "txid": histObj.txHash
        ]
        
        let paramsForMsgSend: NSDictionary = [
            "type": SocketMessageType.multisigView.rawValue,
            "from": "",              // not requied
            "to":"",                 // not requied
            "date": UInt64(Date().timeIntervalSince1970), // time unix
            "status": 0,
            "payload": payloadForView
        ]
        
        socketManager.sendMsg(params: paramsForMsgSend) { (answerDict, err) in
            if err != nil {
                //FIXME: error handling
                completion(Result.failure("wrong data"))
            } else {
                let payloadDict = answerDict!["payload"] as! String
                if payloadDict == "viewed" {
                    completion(Result.success(payloadDict))
                } else {
                    completion(Result.failure("wrong data"))
                }
            }
        }
    }
}

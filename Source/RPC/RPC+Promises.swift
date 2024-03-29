//
//  RPC+Promises.swift
//  FUNCOIN
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit

// MARK: - Promise helpers
private extension RPC {
    func responseError(_ response: Response) -> FUNCOINError {
        if let error = response.error {
            return FUNCOINError.nodeError(desc: error.message)
        }
        return FUNCOINError.nodeError(desc: "Invalid value from FUNCOIN node")
    }

    func apiPromise<T>(_ method: Method, parameters: [Encodable]) -> Promise<T> {
        let request = RequestFabric.prepareRequest(method, parameters: parameters)
        return dispatch(request).map(on: requestDispatcher.queue) { response in
            guard let value: T = response.getValue() else {
                throw self.responseError(response)
            }
            return value
        }

    }
}

// MARK: - API Promises
internal extension RPC {
    func peerCountPromise() -> Promise<BigUInt> {
        return apiPromise(.peerCount, parameters: [])
    }

    func peersInfoPromise() -> Promise<PeerInfo> {
        return apiPromise(.peersInfo, parameters: [])
    }

    func blockNumberPromise() -> Promise<BigUInt> {
        return apiPromise(.blockNumber, parameters: [])
    }

    func sendRawTransactionPromise(signedTx: String) -> Promise<TransactionSendingResult> {
        return apiPromise(.sendRawTransaction, parameters: [signedTx])
    }

    func getVersionPromise() -> Promise<Version> {
        return apiPromise(.getVersion, parameters: [])
    }

    func getBlockByHashPromise(hash: String, fullTransactions: Bool) -> Promise<Block> {
        return apiPromise(.getBlockByHash, parameters: [hash, fullTransactions])
    }

    func getBlockByNumberPromise(number: String, fullTransactions: Bool) -> Promise<Block> {
        return apiPromise(.getBlockByNumber, parameters: [number, fullTransactions])
    }

    func getTransactionReceiptPromise(txhash: String) -> Promise<TransactionReceipt> {
        return apiPromise(.getTransactionReceipt, parameters: [txhash])
    }

    func getLogsPromise(filter: Filter) -> Promise<[EventLog]> {
        return apiPromise(.getLogs, parameters: [filter])
    }

    func callPromise(request: CallRequest, blockNumber: String) -> Promise<String> {
        return apiPromise(.call, parameters: [request, blockNumber])
    }

    func getTransactionPromise(txhash: String) -> Promise<TransactionDetails> {
        return apiPromise(.getTransaction, parameters: [txhash])
    }

    func getTransactionCountlPromise(address: String, blockNumber: String) -> Promise<BigUInt> {
        return apiPromise(.getTransactionCount, parameters: [address, blockNumber])
    }

    func getCodePromise(address: String, blockNumber: String) -> Promise<String> {
        return apiPromise(.getCode, parameters: [address, blockNumber])
    }

    func getAbiPromise(address: String, blockNumber: String) -> Promise<String> {
        return apiPromise(.getAbi, parameters: [address, blockNumber])
    }

    func getBalancePromise(address: String, blockNumber: String) -> Promise<BigUInt> {
       return apiPromise(.getBalance, parameters: [address, blockNumber])
    }

    func newFilterPromise(filter: Filter) -> Promise<BigUInt> {
       return apiPromise(.newFilter, parameters: [filter])
    }

    func newBlockFilterPromise() -> Promise<BigUInt> {
       return apiPromise(.newBlockFilter, parameters: [])
    }

    func uninstallFilterPromise(filterID: BigUInt) -> Promise<Bool> {
       return apiPromise(.uninstallFilter, parameters: [filterID.toHexString().addHexPrefix()])
    }

    func getFilterChangesPromise(filterID: BigUInt) -> Promise<[EventLog]> {
        return apiPromise(.getFilterChanges, parameters: [filterID.toHexString().addHexPrefix()])
    }

    func getFilterLogsPromise(filterID: BigUInt) -> Promise<[EventLog]> {
        return apiPromise(.getFilterLogs, parameters: [filterID.toHexString().addHexPrefix()])
    }

    func getTransactionProofPromise(txhash: String) -> Promise<String> {
        return apiPromise(.getTransactionProof, parameters: [txhash])
    }

    func getMetaDataPromise(blockNumber: String) -> Promise<MetaData> {
        return apiPromise(.getMetaData, parameters: [blockNumber])
    }

    func getBlockHeaderPromise(blockNumber: String) -> Promise<String> {
        return apiPromise(.getBlockHeader, parameters: [blockNumber])
    }

    func getStateProofPromise(address: String, key: String, blockNumber: String) -> Promise<String> {
     return apiPromise(.getStateProof, parameters: [address, key, blockNumber])
    }
}

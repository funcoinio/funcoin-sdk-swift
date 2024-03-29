//
//  Signer.swift
//  FUNCOIN
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

// FUNCOIN Transaction Signer
public struct Signer {
    public init() {}

    // Sign a transaction using private key.
    // Value of transaction may not exceed max of UInt256.
    public func sign(transaction: Transaction, with privateKey: String) throws -> String {
        guard let value = Signer.convert(value: transaction.value) else {
            throw TransactionError.valueOverflow
        }
        var tx = ethTransaction()

        tx.nonce = transaction.nonce
        tx.quota = transaction.quota
        tx.data = transaction.data ?? Data()
        tx.value = value
        tx.validUntilBlock = transaction.validUntilBlock

        tx.version = transaction.version
        switch transaction.version {
        case 0:
            tx.chainID = UInt32(transaction.chainId)!
            if let to = transaction.to {
                tx.to = to.address.stripHexPrefix().lowercased()
            }
        case 1, 2:
            guard let chainId = BigUInt.fromHex(transaction.chainId),
                let chainIdU256 = chainId.toUInt256Hex(),
                let chainIDV1 = Data.fromHex(chainIdU256) else {
                    throw TransactionError.chainIdInvalid
            }
            tx.chainIDV1 = chainIDV1
            if let to = transaction.to {
                tx.toV1 = Data.fromHex(to.address)!
            }
        default:
            throw TransactionError.versionNotSupported
        }

        let binaryData = try! tx.serializedData()
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw TransactionError.privateKeyIsNull
        }
        let protobufHash = binaryData.sha3(.keccak256)
        let (compressedSignature, _): (Data, Data)
        do {
            (compressedSignature, _) = try Secp256k1.signForRecovery(hash: protobufHash, privateKey: privateKeyData, useExtraEntropy: false)
        } catch {
            throw TransactionError.signatureIncorrect
        }

        var unverifiedTx = ethUnverifiedTransaction()
        unverifiedTx.transaction = tx
        unverifiedTx.signature = compressedSignature
        unverifiedTx.crypto = .default
        let unverifiedData = try! unverifiedTx.serializedData()
        return unverifiedData.toHexString().addHexPrefix()
    }

    // Convert value to bytes32
    // - Returns: Bytes32 data, or nil if value is larger than 256bit max.
    // Value must be encoded as fixed length (32) bytes
    static func convert(value: BigUInt) -> Data? {
        if let hex = value.toUInt256Hex() {
            return Data.fromHex(hex)!
        }

        return nil
    }
}

extension Address {
    func toUInt256Hex() -> String {
        let bigint = BigUInt.fromHex(address)!
        return bigint.toUInt256Hex()!
    }
}

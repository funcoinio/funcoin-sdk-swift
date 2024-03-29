//
//  SignerTests.swift
//  FUNCOINTests
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import FUNCOIN

class SignerTests: XCTestCase {
    func testSignTx() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let tx = Transaction(
            nonce: "12345",
            quota: 1_000_000,
            validUntilBlock: 999_999,
            data: Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!,
            chainId: "1",
            version: 0
        )
        guard let signed = try? Signer().sign(transaction: tx, with: privateKey) else {
            return XCTFail("Sign tx failed")
        }
        XCTAssertEqual(signed, "0x0aa6021205313233343518c0843d20bf843d2af0016060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d4058600293220000000000000000000000000000000000000000000000000000000000000000038011241c7b51f2b634a2bb6acb0956a11f71889a88c4bbac2098b39bc3c5c0e151b45931217c0d1e30c1bec872e619273003098e453332c89690b0670fb02a35a53808e00")
    }

    func testSignAnotherTx() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let tx = Transaction(
            nonce: "57a4558948eb422bab36f1ca0f0354e7",
            quota: 1_000_000,
            validUntilBlock: 1_470_441,
            data: Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!,
            chainId: "1",
            version: 0
        )
        guard let signed = try? Signer().sign(transaction: tx, with: privateKey) else {
            return XCTFail("Sign tx failed")
        }
        XCTAssertEqual(signed, "0x0ac1021220353761343535383934386562343232626162333666316361306630333534653718c0843d20e9df592af0016060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d40586002932200000000000000000000000000000000000000000000000000000000000000000380112410167c108d0919a02a43219e3a52fe3cddbe0ac8b9d2271f429c2b09cdad481536596976aa166e66d2b30451a54e1a405bfbc5780538abf0caedbddd4dcbf732200")
    }

    func testSignTxWithWrongPrivateKey() {
        let tx = Transaction(
            to: Address("0x0000000000000000000000000000000000000000"),
            nonce: "12345",
            quota: 1_000_000,
            validUntilBlock: 999_999,
            data: Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!,
            chainId: "1",
            version: 0
        )
        do {
            _ = try Signer().sign(transaction: tx, with: "0xeeeeeeeeeeeeee")
            XCTFail("Sign tx should fail")
        } catch let err {
            XCTAssertTrue(err is TransactionError)
        }
    }

    func testSignTxWithOverflowValue() {
        let tx = Transaction(
            to: Address("0x0000000000000000000000000000000000000000"),
            nonce: "12345",
            quota: 1_000_000,
            validUntilBlock: 999_999,
            value: BigUInt("10", radix: 2)!.power(256),
            chainId: "1",
            version: 0
        )
        do {
            _ = try Signer().sign(transaction: tx, with: "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
            XCTFail("Sign tx should fail")
        } catch let err {
            XCTAssertTrue(err is TransactionError)
        }
    }

    // Load and test all JSON fixtures
    func testJSONFixtures() {
        let txFixtures = jsonFiles(in: "transactions") + jsonFiles(in: "transactions/v1")
        txFixtures.forEach { (file) in
            let json = load(jsonFile: file) as! [String: Any]
            let txData = json["tx"] as! [String: String?]

            let address: Address?
            if let to = txData["to"] as? String {
                address = Address(to)
            } else {
                address = nil
            }

            let data: Data?
            if let dataString = txData["data"] as? String {
                data = Data.fromHex(dataString)
            } else {
                data = nil
            }

            let tx = Transaction(
                to: address,
                nonce: txData["nonce"] as? String ?? UUID().uuidString,
                quota: UInt64(txData["quota"] as? String ?? "1000000")!,
                validUntilBlock: UInt64(txData["validUntilBlock"] as? String ?? "999999")!,
                data: data,
                value: BigUInt(txData["value"] as? String ?? "0")!,
                chainId: txData["chainId"] as? String ?? "1",
                version: UInt32(txData["version"] as? String ?? "0")!
            )
            if let hasError = json["hasError"] as? Bool, hasError {
                do {
                    _ = try Signer().sign(transaction: tx, with: txData["privateKey"] as? String ?? "0x")
                    XCTFail("Sign tx should fail for \(file)")
                } catch let err {
                    XCTAssertTrue(err is TransactionError)
                }
            } else {
                guard let signed = try? Signer().sign(transaction: tx, with: json["privateKey"] as? String ?? "0x") else {
                    return XCTFail("Sign tx failed for \(file)")
                }
                XCTAssertEqual(signed, json["signed"] as! String)
            }
        }
    }

    func testValueConvert() {
        let values: [BigUInt: String] = [
            0:                                          "0000000000000000000000000000000000000000000000000000000000000000",
            1:                                          "0000000000000000000000000000000000000000000000000000000000000001",
            BigUInt(10).power(18):                      "0000000000000000000000000000000000000000000000000de0b6b3a7640000",
            BigUInt("10", radix: 2)!.power(256) - 1:    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            ]
        values.forEach { value, hex in
            let result = Signer.convert(value: value)!.toHexString()
            XCTAssertEqual(result, hex)
        }

        XCTAssertNil(Signer.convert(value: BigUInt("10", radix: 2)!.power(256)))
    }
}

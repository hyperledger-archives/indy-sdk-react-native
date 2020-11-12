//
// Copyright 2019 ABSA Group Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Indy

@objc(IndySdk)
class IndySdk : NSObject {
    
    @objc func sampleMethod(_ stringArgument: String, numberArgument: NSNumber,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) {
      resolve("result")
    }
    
    @objc func createWallet(_ config: String, credentials: String,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let indyWallet = IndyWallet()
      
      indyWallet.createWallet(withConfig: config, credentials: credentials, completion: completion(resolve, reject))
    }
    
    @objc func openWallet(_ config: String, credentials: String,
                          resolver resolve: @escaping RCTPromiseResolveBlock,
                          rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let indyWallet = IndyWallet()
      
      indyWallet.open(withConfig: config, credentials: credentials, completion: completionWithIndyHandle(resolve, reject))
    }
    
    @objc func closeWallet(_ walletHandle: NSNumber,
                         resolver resolve: @escaping RCTPromiseResolveBlock,
                         rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      let indyWallet = IndyWallet()
      
      indyWallet.close(withHandle: whNumber, completion: completion(resolve, reject))
    }

    @objc func deleteWallet(_ config: String, credentials: String,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let indyWallet = IndyWallet()
      
      indyWallet.delete(withConfig: config, credentials: credentials, completion: completion(resolve, reject))
    }
    
    @objc func exportWallet(_ walletHandle: NSNumber, exportConfig: String,
                           resolver resolve: @escaping RCTPromiseResolveBlock,
                           rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      let indyWallet = IndyWallet()
      
      indyWallet.export(withHandle: whNumber, exportConfigJson: exportConfig, completion: completion(resolve, reject))
    }
    
    @objc func importWallet(_ config: String, credentials: String, importConfig: String,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) {
      let indyWallet = IndyWallet()
      indyWallet.import(withConfig: config, credentials: credentials, importConfigJson: importConfig, completion: completion(resolve, reject))
    }
    
    // did
    
    @objc func createAndStoreMyDid(_ didJson: String!, walletHandle: NSNumber,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      
      func completion(error: Error?, did: String?, verkey: String?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve([did, verkey])
        }
      }
      
      IndyDid.createAndStoreMyDid(didJson, walletHandle: whNumber, completion: completion)
    }
    
    @objc func keyForDid(_ did: String!, poolHandle: NSNumber, walletHandle: NSNumber,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) {
      let phNumber:Int32  = Int32(poolHandle)
      let whNumber:Int32  = Int32(walletHandle)
      
      IndyDid.key(forDid: did, poolHandle: phNumber, walletHandle: whNumber, completion: completionWithVerkey(resolve, reject))
    }
    
    @objc func keyForLocalDid(_ did: String!, walletHandle: NSNumber,
                              resolver resolve: @escaping RCTPromiseResolveBlock,
                              rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      
      IndyDid.key(forLocalDid: did, walletHandle: whNumber, completion: completionWithVerkey(resolve, reject))
    }
    
    @objc func storeTheirDid(_ identityJSON: String!, walletHandle: NSNumber,
                              resolver resolve: @escaping RCTPromiseResolveBlock,
                              rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      
      IndyDid.storeTheirDid(identityJSON, walletHandle: whNumber, completion: completion(resolve, reject))
    }
    
    @objc func createPairwise(_ theirDid: String!, myDid: String!, metadata: String!, walletHandle: NSNumber,
                             resolver resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      
      IndyPairwise.createPairwise(forTheirDid: theirDid, myDid: myDid, metadata: metadata, walletHandle: whNumber, completion: completion(resolve, reject))
    }
    
    @objc func getPairwise(_ theirDid: String!, walletHandle: NSNumber,
                           resolver resolve: @escaping RCTPromiseResolveBlock,
                           rejecter reject: @escaping RCTPromiseRejectBlock) {
      let whNumber:Int32  = Int32(walletHandle)
      IndyPairwise.getForTheirDid(theirDid, walletHandle: whNumber, completion: completionWithPairwiseInfo(resolve, reject))
    }
    
    // crypto
    
    @objc func cryptoAnonCrypt(_ message: String, theirKey: String!,
                               resolver resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let messageData = message.data(using: .utf8)
      IndyCrypto.anonCrypt(messageData, theirKey: theirKey, completion: completionWithData(resolve, reject))
    }
    
    @objc func cryptoAnonDecrypt(_ encryptedMessage: Array<UInt8>, myKey: String!, walletHandle: NSNumber,
                                 resolver resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      let encryptedMessageData = Data(bytes: encryptedMessage)
      IndyCrypto.anonDecrypt(encryptedMessageData, myKey: myKey, walletHandle: whNumber, completion: completionWithData(resolve, reject))
    }
    
    @objc func cryptoAuthCrypt(_ message: String, myKey: String!, theirKey: String!, walletHandle: NSNumber,
                               resolver resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyCrypto.authCrypt(message.data(using: .utf8), myKey: myKey, theirKey: theirKey, walletHandle: whNumber, completion: completionWithData(resolve, reject))
    }
    
    @objc func cryptoAuthDecrypt(_ encryptedMessage: Array<UInt8>, myKey: String!, walletHandle: NSNumber,
                                 resolver resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      
      IndyCrypto.authDecrypt(Data(bytes: encryptedMessage), myKey: myKey, walletHandle: whNumber, completion: completionWithTheirKeyAndData(resolve, reject))
    }
    
    @objc func cryptoSign(_ wh: NSNumber, signerVk: String, message: Array<UInt8>, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber = Int32(truncating: wh)
        let messageData = Data(message)
        IndyCrypto.signMessage(messageData, key: signerVk, walletHandle: whNumber, completion: completionWithData(resolve, reject))
    }
    
    @objc func cryptoVerify(_ signerVk: String, message: Array<UInt8>, signature: Array<UInt8>, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let messageData = Data(message)
        let signatureData = Data(signature)
        IndyCrypto.verifySignature(signatureData, forMessage: messageData, key: signerVk, completion: completionWithBool(resolve, reject))
    }
    
    @objc func packMessage(_ wh: NSNumber, message: Array<UInt8>, receiverKeys: String, senderVk: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber = Int32(truncating: wh)
        let messageData = Data(message)
        IndyCrypto.packMessage(messageData, receivers: receiverKeys, sender: senderVk, walletHandle: whNumber, completion: completionWithData(resolve, reject))
    }
    
    @objc func unpackMessage(_ wh: NSNumber, jwe: Array<UInt8>, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber = Int32(truncating: wh)
        let jweData = Data(jwe)
        IndyCrypto.unpackMessage(jweData, walletHandle: whNumber, completion: completionWithData(resolve, reject))
    }
    
    
    // pool
    
    @objc func setProtocolVersion(_ protocolVersion: NSNumber,
                                  resolver resolve: @escaping RCTPromiseResolveBlock,
                                  rejecter reject: @escaping RCTPromiseRejectBlock) {
      IndyPool.setProtocolVersion(protocolVersion, completion: completion(resolve, reject));
    }
    
    @objc func createPoolLedgerConfig(_ name: String, poolConfig: String,
                                      resolver resolve: @escaping RCTPromiseResolveBlock,
                                      rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      IndyPool.createPoolLedgerConfig(withPoolName: name, poolConfig: poolConfig, completion: completion(resolve, reject))
    }
    
    @objc func openLedger(_ name: String, poolConfig: String?,
                          resolver resolve: @escaping RCTPromiseResolveBlock,
                          rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
      IndyPool.openLedger(withName: name, poolConfig: poolConfig, completion: completionWithIndyHandle(resolve, reject))
    }
    
    @objc func closePoolLedger(_ poolHandle: NSNumber,
                               resolver resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) {
      let phNumber:Int32  = Int32(poolHandle)
      IndyPool.closeLedger(withHandle: phNumber, completion: completion(resolve, reject))
    }
    
    // ledger
    
    @objc func submitRequest(_ requestJSON: String, poolHandle: NSNumber,
                             resolver resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let phNumber:Int32  = Int32(poolHandle)
      IndyLedger.submitRequest(requestJSON, poolHandle: phNumber, completion: completionWithString(resolve, reject))
    }
    
    @objc func buildGetSchemaRequest(_ submitterDid: String, id: String,
                                      resolver resolve: @escaping RCTPromiseResolveBlock,
                                      rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      IndyLedger.buildGetSchemaRequest(
        withSubmitterDid: !submitterDid.isEmpty ? submitterDid : nil,
        id: id,
        completion: completionWithString(resolve, reject)
      )
    }
    
    @objc func parseGetSchemaResponse(_ getSchemaResponse: String,
                             resolver resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      IndyLedger.parseGetSchemaResponse(getSchemaResponse, completion: completionWithStringPair(resolve, reject))
    }
    
    @objc func buildGetCredDefRequest(_ submitterDid: String, id: String,
                                      resolver resolve: @escaping RCTPromiseResolveBlock,
                                      rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      IndyLedger.buildGetCredDefRequest(
        withSubmitterDid: !submitterDid.isEmpty ? submitterDid : nil,
        id: id,
        completion: completionWithString(resolve, reject)
      )
    }
    
    @objc func parseGetCredDefResponse(_ getCredDefResponse: String,
                                       resolver resolve: @escaping RCTPromiseResolveBlock,
                                       rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      IndyLedger.parseGetCredDefResponse(getCredDefResponse, completion: completionWithStringPair(resolve, reject))
    }
    
    @objc func builGetAttribRequest(_ submitterDid: String,
                                    targetDid: String,
                                    raw: String,
                                    hash: String,
                                    enc: String,
                                    resolver resolve: @escaping RCTPromiseResolveBlock,
                                    rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        IndyLedger.buildGetAttribRequest(withSubmitterDid: submitterDid, targetDID: targetDid, raw: raw, hash: hash, enc: enc, completion: completionWithString(resolve, reject))
    }
    
    @objc func buildGetNymRequest(_ submitterDid: String?,
                                 targetDid: String,
                                 resolver resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        IndyLedger.buildGetNymRequest(withSubmitterDid: submitterDid, targetDID: targetDid, completion: completionWithString(resolve, reject))
    }

    @objc func parseGetNymResponse(_ response: String,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        IndyLedger.parseGetNymResponse(response, completion: completionWithString(resolve, reject))
    }
    
    
    
    // anoncreds
    
    @objc func proverCreateMasterSecret(_ masterSecretId: String, walletHandle: NSNumber,
                                       resolver resolve: @escaping RCTPromiseResolveBlock,
                                       rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)

      IndyAnoncreds.proverCreateMasterSecret(
        !masterSecretId.isEmpty ? masterSecretId : nil,
        walletHandle: whNumber,
        completion: completionWithString(resolve, reject)
      )
    }
    
    @objc func proverCreateCredentialReq(_ credOfferJSON: String, credentialDefJSON: String, proverDID: String, masterSecretID: String, walletHandle: NSNumber,
                                        resolver resolve: @escaping RCTPromiseResolveBlock,
                                        rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverCreateCredentialReq(
        forCredentialOffer: credOfferJSON,
        credentialDefJSON: credentialDefJSON,
        proverDID: proverDID,
        masterSecretID: masterSecretID,
        walletHandle: whNumber,
        completion: completionWithStringPair(resolve, reject)
      )
    }
    
    @objc func proverStoreCredential(_ credJson: String, credID: String, credReqMetadataJSON: String, credDefJSON: String, revRegDefJSON: String, walletHandle: NSNumber,
                                        resolver resolve: @escaping RCTPromiseResolveBlock,
                                        rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverStoreCredential(
        credJson,
        credID: !credID.isEmpty ? credID : nil,
        credReqMetadataJSON: credReqMetadataJSON,
        credDefJSON: credDefJSON,
        revRegDefJSON: !revRegDefJSON.isEmpty ? revRegDefJSON : nil,
        walletHandle: whNumber, completion: completionWithString(resolve, reject))
    }
    
    @objc func proverGetCredentials(_ filterJSON: String, walletHandle: NSNumber,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverGetCredentials(forFilter: filterJSON, walletHandle: whNumber, completion: completionWithString(resolve, reject))
    }
    
    @objc func proverGetCredential(_ credId: String, walletHandle: NSNumber,
                                        resolver resolve: @escaping RCTPromiseResolveBlock,
                                        rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverGetCredential(withId: credId, walletHandle: whNumber, completion: completionWithString(resolve, reject))
    }
    
    @objc func proverGetCredentialsForProofReq(_ proofReqJSON: String, walletHandle: NSNumber,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverGetCredentials(forProofReq: proofReqJSON, walletHandle: whNumber, completion: completionWithString(resolve, reject))
    }
    
    @objc func proverCreateProofForRequest(_ proofReqJSON: String, requestedCredentialsJSON: String, masterSecretID: String, schemasJSON: String, credentialDefsJSON: String, revocStatesJSON: String, walletHandle: NSNumber,
                                               resolver resolve: @escaping RCTPromiseResolveBlock,
                                               rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
      let whNumber:Int32  = Int32(walletHandle)
      IndyAnoncreds.proverCreateProof(
        forRequest: proofReqJSON,
        requestedCredentialsJSON: requestedCredentialsJSON,
        masterSecretID: masterSecretID,
        schemasJSON: schemasJSON,
        credentialDefsJSON: credentialDefsJSON,
        revocStatesJSON: revocStatesJSON,
        walletHandle: whNumber,
        completion: completionWithString(resolve, reject)
      )
    }
    
    // non_secret
    
    @objc func addWalletRecord(_ wh: NSNumber, type: String, id: String, value: String, tags: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.addRecord(inWallet: whNumber, type: type, id: id, value: value, tagsJson: tags, completion: completion(resolve, reject))
    }
    
    @objc func updateWalletRecordValue(_ wh: NSNumber, type: String, id: String, value: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.updateRecordValue(inWallet: whNumber, type: type, id: id, value: value, completion: completion(resolve, reject))
    }
    
    @objc func updateWalletRecordTags(_ wh: NSNumber, type: String, id: String, tags: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.updateRecordTags(inWallet: whNumber, type: type, id: id, tagsJson: tags, completion: completion(resolve, reject))
    }
    
    @objc func addWalletRecordTags(_ wh: NSNumber, type: String, id: String, tags: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.addRecordTags(inWallet: whNumber, type: type, id: id, tagsJson: tags, completion: completion(resolve, reject))
    }
    
    @objc func deleteWalletRecordTags(_ wh: NSNumber, type: String, id: String, tags: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.deleteRecordTags(inWallet: whNumber, type: type, id: id, tagsNames: tags, completion: completion(resolve, reject))
    }

    @objc func deleteWalletRecord(_ wh: NSNumber, type: String, id: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.deleteRecord(inWallet: whNumber, type: type, id: id, completion: completion(resolve, reject))
    }
    
    @objc func getWalletRecord(_ wh: NSNumber, type: String, id: String, options: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.getRecordFromWallet(whNumber, type: type, id: id, optionsJson: options, completion: completionWithString(resolve, reject))
    }
    
    @objc func openWalletSearch(_ wh: NSNumber, type: String, query: String, options: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        IndyNonSecrets.openSearch(inWallet: whNumber, type: type, queryJson: query, optionsJson: options, completion: completionWithIndyHandle(resolve, reject))
    }
    
    @objc func fetchWalletSearchNextRecords(_ wh: NSNumber, sh: NSNumber, count: NSNumber, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let whNumber:Int32 = Int32(truncating: wh)
        let shNumber:Int32 = Int32(truncating: sh)
        IndyNonSecrets.fetchNextRecords(fromSearch: shNumber, walletHandle: whNumber, count: count, completion: completionWithString(resolve, reject))
    }
    
    @objc func closeWalletSearch(_ sh: NSNumber, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let shNumber:Int32 = Int32(truncating: sh)
        IndyNonSecrets.closeSearch(withHandle: shNumber, completion: completion(resolve, reject))
    }
    
    // completion functions
    
    func completion(_ resolve: @escaping RCTPromiseResolveBlock,
                    _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?) -> Void {
      func completion(error: Error?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(nil)
        }
      }
      
      return completion
    }
    
    func completionWithIndyHandle(_ resolve: @escaping RCTPromiseResolveBlock,
                                    _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ wh: IndyHandle) -> Void {
      func completion(error: Error?,  ih: IndyHandle) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(ih)
        }
      }
      
      return completion
    }
    
    func completionWithVerkey(_ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ verkey: String?) -> Void {
      func completion(error: Error?,  verkey: String?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(verkey)
        }
      }
      
      return completion
    }
    
    func completionWithPairwiseInfo(_ resolve: @escaping RCTPromiseResolveBlock,
                                    _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ pairwiseInfo: String?) -> Void {
      func completion(error: Error?,  pairwiseInfo: String?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(pairwiseInfo)
        }
      }
      
      return completion
    }
    
    func completionWithData(_ resolve: @escaping RCTPromiseResolveBlock,
                            _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ data: Data?) -> Void {
      func completion(error: Error?, data: Data?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(NSArray(array: [UInt8](data!)))
        }
      }
      
      return completion
    }
    
    func completionWithTheirKeyAndData(_ resolve: @escaping RCTPromiseResolveBlock,
                                       _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ theirKey: String?, _ data: Data?) -> Void {
      func completion(error: Error?, theirKey: String?, data: Data?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve([theirKey!, NSArray(array: [UInt8](data!))])
        }
      }
      
      return completion
    }
    
    func completionWithString(_ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ result: String?) -> Void {
      func completion(error: Error?,  result: String?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(result)
        }
      }
      
      return completion
    }
    
    func completionWithBool(_ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ result: Bool) -> Void {
      func completion(error: Error?,  result: Bool) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve(result)
        }
      }
      
      return completion
    }
    
    func completionWithStringPair(_ resolve: @escaping RCTPromiseResolveBlock,
                                  _ reject: @escaping RCTPromiseRejectBlock) -> (_ error: Error?, _ string1: String?, _ string2: String?) -> Void {
      func completion(error: Error?,  string1: String?, string2: String?) -> Void {
        let code = (error! as NSError).code
        if code != 0 {
          reject("\(code)", createJsonError(error!, code), error)
        } else {
          resolve([string1, string2])
        }
      }
      
      return completion
    }
    
    struct ErrorMessage: Codable {
      var message: String
      var code: Int
    }
    
    func createJsonError(_ error: Error, _ code: Int) -> String! {
      let jsonEncoder = JSONEncoder()
      do {
        let message = "IndyBridge: \(String(describing: error))"
        let jsonData = try jsonEncoder.encode(ErrorMessage(message: message, code: code))
        return String(data: jsonData, encoding: .utf8)
      } catch {
        // This code can perhaps replace implementation above
        return "{\"message\": \"IndyBridge: \(String(describing: error))\"}"
      }
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
      return false
    }   
}

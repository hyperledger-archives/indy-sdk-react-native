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

#if __has_include(<React/RCTViewManager.h>)
#import <React/RCTViewManager.h>
#elif __has_include("RCTViewManager.h")
#import "RCTViewManager.h"
#else
#import "React/RCTViewManager.h" // Required when used as a Pod in a Swift project
#endif

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTEventDispatcher.h")
#import "RCTEventDispatcher.h"
#else
#import "React/RCTEventDispatcher.h" // Required when used as a Pod in a Swift project
#endif

@interface RCT_EXTERN_MODULE(IndySdk, NSObject)

RCT_EXTERN_METHOD(sampleMethod: (NSString *)stringArgument numberArgument:(nonnull NSNumber *)numberArgument
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// wallet
RCT_EXTERN_METHOD(createWallet: (NSString *)config credentials:(NSString *)credentials
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openWallet: (NSString *)config credentials:(NSString *)credentials
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(closeWallet: (nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(deleteWallet: (NSString *)config credentials:(NSString *)credentials
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(exportWallet: (nonnull NSNumber *)walletHandle exportConfig:(NSString *)exportConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(importWallet: (NSString *)config credentials:(NSString *)credentials importConfig:(NSString *)importConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// did
RCT_EXTERN_METHOD(createAndStoreMyDid: (NSString *)didJson walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(keyForDid: (NSString *)did poolHandle:(nonnull NSNumber *)poolHandle walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(keyForLocalDid: (NSString *)did walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(storeTheirDid: (NSString *)identityJSON walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// pairwise
RCT_EXTERN_METHOD(createPairwise: (NSString *)theirDid myDid:(NSString *)myDid metadata:(NSString *)metadata walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getPairwise: (NSString *)theirDid walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// crypto
RCT_EXTERN_METHOD(cryptoAnonCrypt: (NSString *)message theirKey:(NSString *)theirKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(cryptoAnonDecrypt: (NSArray *)encryptedMessage myKey:(NSString *)myKey walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(cryptoAuthCrypt: (NSString *)message myKey:(NSString *)myKey theirKey:(NSString *)theirKey walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(cryptoAuthDecrypt: (NSArray *)encryptedMessage myKey:(NSString *)myKey walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// pool
RCT_EXTERN_METHOD(createPoolLedgerConfig: (NSString *)name poolConfig:(NSString *)poolConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openLedger: (NSString *)name poolConfig:(NSString *)poolConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setProtocolVersion: (nonnull NSNumber *)protocolVersion
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(closePoolLedger: (nonnull NSNumber *)poolHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// ledger

RCT_EXTERN_METHOD(submitRequest: (NSString *)requestJSON poolHandle:(nonnull NSNumber *)poolHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(buildGetSchemaRequest: (NSString *)submitterDid id:(NSString *)id
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(parseGetSchemaResponse: (NSString *)getSchemaResponse
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(buildGetCredDefRequest: (NSString *)submitterDid id:(NSString *)id
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(parseGetCredDefResponse: (NSString *)getCredDefResponse
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// anoncreds

RCT_EXTERN_METHOD(proverCreateMasterSecret: (NSString *)masterSecretId walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverCreateCredentialReq: (NSString *)credOfferJSON
                  credentialDefJSON:(NSString *)credentialDefJSON
                  proverDID:(NSString *)proverDID
                  masterSecretID:(NSString *)masterSecretID
                  walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverStoreCredential: (NSString *)credJson
                  credID:(NSString *)credID
                  credReqMetadataJSON:(NSString *)credReqMetadataJSON
                  credDefJSON:(NSString *)credDefJSON
                  revRegDefJSON:(NSString *)revRegDefJSON walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverGetCredentials: (NSString *)filter walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverGetCredential: (NSString *)credId walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverGetCredentialsForProofReq: (NSString *)proofReqJSON walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(proverCreateProofForRequest: (NSString *)proofReqJSON
                  requestedCredentialsJSON:(NSString *)requestedCredentialsJSON
                  masterSecretID:(NSString *)masterSecretID
                  schemasJSON:(NSString *)schemasJSON
                  credentialDefsJSON:(NSString *)credentialDefsJSON
                  revocStatesJSON:(NSString *)revocStatesJSON
                  walletHandle:(nonnull NSNumber *)walletHandle
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end

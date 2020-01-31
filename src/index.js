/**
 * Copyright 2019 ABSA Group Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import { NativeModules } from 'react-native'

export type CredOffer = {
  schema_id: string,
  cred_def_id: string,
  // Fields below can depend on Cred Def type
  nonce: string,
  key_correctness_proof: any, // <key_correctness_proof>
}

export type CredDefId = string
export type CredDef = {
  id: string, // identifier of credential definition
  schemaId: string, // identifier of stored in ledger schema
  type: string, // type of the credential definition. CL is the only supported type now.
  tag: string, // allows to distinct between credential definitions for the same issuer and schema
  value: {
    // Dictionary with Credential Definition's data:
    primary: any, // primary credential public key,
    revocation: ?any, // revocation credential public key
  },
  ver: string, // Version of the Credential Definition json
}

export type CredId = string

// Credential json received from issuer
export type Cred = {
  schema_id: string,
  cred_def_id: string,
  rev_reg_def_id: ?string,
  values: {
    // "attr1" : {"raw": "value1", "encoded": "value1_as_int" },
    // "attr2" : {"raw": "value1", "encoded": "value1_as_int" }
    [string]: { raw: any, endcoded: any },
  }, // <see credValues above>,
  // Fields below can depend on Cred Def type
  signature: any, // <signature>
  signature_correctness_proof: any, // <signature_correctness_proof>
}

export type Credential = {
  referent: CredId, // cred_id in the wallet
  attrs?: {
    // "key1":"raw_value1",
    // "key2":"raw_value2"
    [string]: any,
  },
  schema_id: string,
  cred_def_id: string,
  rev_reg_id?: string, // Optional<string>,
  cred_rev_id?: string, // Optional<string>
}

export type MasterSecretId = string

export type RequestedAttribute = string

export type ProofRequest = {
  name: string,
  version: string,
  nonce: string,
  requested_attributes: {
    // set of requested attributes
    [attributeReferent: string]: {
      name: string,
    }, // <attr_referent>: <attr_info>
  },
  requested_predicates: {
    // set of requested predicates
    [attributePredicate: string]: {}, // <predicate_referent>: <predicate_info>
  },
  // Optional<<non_revoc_interval>>
  // If specified prover must proof non-revocation
  // for date in this interval for each attribute
  // (can be overridden on attribute level)
  non_revoked?: any,
}

export type Proof = {
  requested_proof: {
    revealed_attrs: {
      // requested_attr1_id: {sub_proof_index: number, raw: string, encoded: string},
      // requested_attr4_id: {sub_proof_index: number: string, encoded: string},
      [attributeReferent: string]: {
        raw: any,
      },
    },
    unrevealed_attrs: {
      // requested_attr3_id: {sub_proof_index: number}
      [attributeReferent: string]: {},
    },
    self_attested_attrs: {
      // requested_attr2_id: self_attested_value,
      [attributeReferent: string]: {},
    },
    requested_predicates: {
      // requested_predicate_1_referent: {sub_proof_index: int},
      // requested_predicate_2_referent: {sub_proof_index: int},
      [attributePredicate: string]: {},
    },
  },
  proof: {
    proofs: [], // [ <credential_proof>, <credential_proof>, <credential_proof> ],
    aggregated_proof: any, // <aggregated_proof>
  },
  identifiers: [], // [{schema_id, cred_def_id, Optional<rev_reg_id>, Optional<timestamp>}]
}

export type RequestedCredentials = {
  self_attested_attributes: {
    // "self_attested_attribute_referent": string
    [attributeReferent: string]: string,
  },
  requested_attributes: {
    // "requested_attribute_referent_1": {"cred_id": string, "timestamp": Optional<number>, revealed: <bool> }},
    // "requested_attribute_referent_2": {"cred_id": string, "timestamp": Optional<number>, revealed: <bool> }}
    [attributeReferent: string]: {},
  },
  requested_predicates: {
    // "requested_predicates_referent_1": {"cred_id": string, "timestamp": Optional<number> }},
    [string]: {},
  },
}

export type SchemaId = string
export type Schema = {
  id: SchemaId,
  name: string,
  // TODO It would be better to remove `status` attribute, because is part of our business domain and not Indy.
  // This custom attribute shows state of the credential request (when waiting for documents approval).
  status?: string,
}

/**
 * Json - all schemas json participating in the proof request
 *  {
 *    <schema1_id>: <schema1_json>,
 *    <schema2_id>: <schema2_json>,
 *    <schema3_id>: <schema3_json>,
 *  }
 */
export type Schemas = {
  [SchemaId]: Schema,
}

/**
 * Json - all credential definitions json participating in the proof request
 *  {
 *    "cred_def1_id": <credential_def1_json>,
 *    "cred_def2_id": <credential_def2_json>,
 *    "cred_def3_id": <credential_def3_json>,
 *  }
 */
export type CredentialDefs = {
  [CredDefId]: CredDef,
}

/**
 * Json - all revocation states json participating in the proof request
 *  {
 *    "rev_reg_def1_id": {
 *        "timestamp1": <rev_state1>,
 *        "timestamp2": <rev_state2>,
 *    },
 *    "rev_reg_def2_id": {
 *        "timestamp3": <rev_state3>
 *    },
 *    "rev_reg_def3_id": {
 *        "timestamp4": <rev_state4>
 *    },
 *  }
 */
export type RevStates = {}

/**
 * Json - Request data json
 */
export type LedgerRequest = {}

export type LedgerRequestResult = {}

export type CredReq = {
  prover_did: string,
  cred_def_id: string,
  // Fields below can depend on Cred Def type
  blinded_ms?: any, // <blinded_master_secret>,
  blinded_ms_correctness_proof?: any, // <blinded_ms_correctness_proof>,
  nonce?: string,
}

/**
 * Credential request metadata json for further processing of received form Issuer credential.
 */
export type CredReqMetadata = {}

/**
 * Json - revocation registry definition json related to <rev_reg_def_id> in <cred_json>
 */
export type RevRegDef = {}

export type Did = string

export type Verkey = string

export type WalletHandle = number
export type PoolHandle = number

const { IndySdk } = NativeModules

export default {
  sampleMethod(stringArgument, numberArgument) {
    return IndySdk.sampleMethod(stringArgument, numberArgument)
  },

  // wallet

  createWallet(config: Object, credentials: Object): Promise<void> {
    return IndyBridge.createWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  openWallet(config: Object, credentials: Object): Promise<WalletHandle> {
    return IndyBridge.openWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  closeWallet(wh: WalletHandle): Promise<void> {
    if (Platform.OS === 'ios') {
      return IndyBridge.closeWallet(wh.callSomething())
    }
    return IndyBridge.closeWallet()
  },

  deleteWallet(config: Object, credentials: Object): Promise<void> {
    return IndyBridge.deleteWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  // did

  /**
   * Value of passed `wh` parameter will be ignored in Android version of Indy native bridge,
   * because it keeps wallet as a private attribute.
   */
  createAndStoreMyDid(wh: WalletHandle, did: Object): Promise<[Did, Verkey]> {
    return IndyBridge.createAndStoreMyDid(JSON.stringify(did), wh)
  },

  keyForDid(poolHandle: PoolHandle, wh: WalletHandle, did: Did): Promise<Verkey> {
    if (Platform.OS === 'ios') {
      return IndyBridge.keyForDid(did, poolHandle, wh)
    }
    return IndyBridge.keyForDid(did)
  },

  keyForLocalDid(wh: WalletHandle, did: Did): Promise<Verkey> {
    if (Platform.OS === 'ios') {
      return IndyBridge.keyForLocalDid(did, wh)
    }
    return IndyBridge.keyForLocalDid(did)
  },

  storeTheirDid(wh: WalletHandle, identity: {}) {
    if (Platform.OS === 'ios') {
      return IndyBridge.storeTheirDid(JSON.stringify(identity), wh)
    }
    throw new Error(`Unsupported operation! Platform: ${Platform.OS}`)
  },

  // pairwise

  createPairwise(wh: WalletHandle, theirDid: Did, myDid: Did, metadata: string = ''): Promise<void> {
    if (Platform.OS === 'ios') {
      return IndyBridge.createPairwise(theirDid, myDid, metadata, wh)
    }
    return IndyBridge.createPairwise(theirDid, myDid, metadata)
  },

  async getPairwise(wh: WalletHandle, theirDid: Did): Promise<Object> {
    if (Platform.OS === 'ios') {
      return JSON.parse(await IndyBridge.getPairwise(theirDid, wh))
    }
    return JSON.parse(await IndyBridge.getPairwise(theirDid))
  },

  // crypto

  cryptoAnonCrypt(recipientVk: Verkey, messageRaw: Uint8Array): Promise<Array<number>> {
    if (Platform.OS === 'ios') {
      return IndyBridge.cryptoAnonCrypt(messageRaw, recipientVk)
    }

    return IndyBridge.cryptoAnonCrypt(recipientVk, messageRaw)
  },

  cryptoAnonDecrypt(wh: WalletHandle, recipientVk: Verkey, encryptedMsg: Array<number>): Promise<Array<number>> {
    if (Platform.OS === 'ios') {
      return IndyBridge.cryptoAnonDecrypt(encryptedMsg, recipientVk, wh)
    }
    return IndyBridge.cryptoAnonDecrypt(recipientVk, encryptedMsg)
  },

  cryptoAuthCrypt(wh: WalletHandle, senderVk: Verkey, recipientVk: Verkey, messageRaw: string): Promise<Array<number>> {
    if (Platform.OS === 'ios') {
      return IndyBridge.cryptoAuthCrypt(messageRaw, senderVk, recipientVk, wh)
    }
    return IndyBridge.cryptoAuthCrypt(senderVk, recipientVk, messageRaw)
  },

  cryptoAuthDecrypt(
    wh: WalletHandle,
    recipientVk: Verkey,
    encryptedMsgRaw: Array<number>
  ): Promise<[Verkey, Array<number>]> {
    if (Platform.OS === 'ios') {
      return IndyBridge.cryptoAuthDecrypt(encryptedMsgRaw, recipientVk, wh)
    }
    return IndyBridge.cryptoAuthDecrypt(recipientVk, encryptedMsgRaw)
  },

  // pool

  createPoolLedgerConfig(poolName: string, poolConfig: string): Promise<void> {
    return IndyBridge.createPoolLedgerConfig(poolName, poolConfig)
  },

  openPoolLedger(poolName: string, poolConfig: string): Promise<PoolHandle> {
    if (Platform.OS === 'ios') {
      return IndyBridge.openLedger(poolName, poolConfig)
    }
    return IndyBridge.openPoolLedger(poolName, poolConfig)
  },

  setProtocolVersion(protocolVersion: number): Promise<void> {
    return IndyBridge.setProtocolVersion(protocolVersion)
  },

  closePoolLedger(ph: PoolHandle): Promise<void> {
    if (Platform.OS === 'ios') {
      return IndyBridge.closePoolLedger(ph)
    }
    return IndyBridge.closePoolLedger()
  },

  async submitRequest(poolHandle: PoolHandle, request: LedgerRequest): Promise<LedgerRequestResult> {
    if (Platform.OS === 'ios') {
      return JSON.parse(await IndyBridge.submitRequest(request, poolHandle))
    }
    return JSON.parse(await IndyBridge.submitRequest(request))
  },

  buildGetSchemaRequest(submitterDid: Did, id: string): Promise<LedgerRequest> {
    return IndyBridge.buildGetSchemaRequest(submitterDid, id)
  },

  parseGetSchemaResponse(getSchemaResponse: LedgerRequestResult): Promise<[SchemaId, Schema]> {
    return IndyBridge.parseGetSchemaResponse(JSON.stringify(getSchemaResponse))
  },

  buildGetCredDefRequest(submitterDid: Did, id: string): Promise<LedgerRequestResult> {
    return IndyBridge.buildGetCredDefRequest(submitterDid, id)
  },

  parseGetCredDefResponse(getCredDefResponse: LedgerRequestResult): Promise<[CredDefId, CredDef]> {
    return IndyBridge.parseGetCredDefResponse(JSON.stringify(getCredDefResponse))
  },

  proverCreateMasterSecret(wh: WalletHandle, masterSecretId: ?MasterSecretId): Promise<MasterSecretId> {
    if (Platform.OS === 'ios') {
      return IndyBridge.proverCreateMasterSecret(masterSecretId, wh)
    }
    return IndyBridge.proverCreateMasterSecret(masterSecretId)
  },

  proverCreateCredentialReq(
    wh: WalletHandle,
    proverDid: Did,
    credOffer: CredOffer,
    credDef: CredDef,
    masterSecretId: MasterSecretId
  ): Promise<[CredReq, CredReqMetadata]> {
    if (Platform.OS === 'ios') {
      return IndyBridge.proverCreateCredentialReq(
        JSON.stringify(credOffer),
        JSON.stringify(credDef),
        proverDid,
        masterSecretId,
        wh
      )
    }
    return IndyBridge.proverCreateCredentialReq(
      proverDid,
      JSON.stringify(credOffer),
      JSON.stringify(credDef),
      masterSecretId
    )
  },

  proverStoreCredential(
    wh: WalletHandle,
    credId: CredId,
    credReqMetadata: CredReqMetadata,
    cred: Cred,
    credDef: CredDef,
    revRegDef: ?RevRegDef
  ): Promise<CredId> {
    if (Platform.OS === 'ios') {
      return IndyBridge.proverStoreCredential(
        JSON.stringify(cred),
        credId,
        JSON.stringify(credReqMetadata),
        JSON.stringify(credDef),
        revRegDef && JSON.stringify(revRegDef),
        wh
      )
    }
    return IndyBridge.proverStoreCredential(
      credId,
      JSON.stringify(credReqMetadata),
      JSON.stringify(cred),
      JSON.stringify(credDef),
      revRegDef && JSON.stringify(revRegDef)
    )
  },

  async proverGetCredentials(wh: WalletHandle, filter: {} = {}): Promise<Credential[]> {
    if (Platform.OS === 'ios') {
      return JSON.parse(await IndyBridge.proverGetCredentials(JSON.stringify(filter), wh))
    }
    return JSON.parse(await IndyBridge.proverGetCredentials(JSON.stringify(filter)))
  },

  async proverGetCredential(wh: WalletHandle, credId: CredId): Promise<Credential> {
    if (Platform.OS === 'ios') {
      return JSON.parse(await IndyBridge.proverGetCredential(credId, wh))
    }
    return JSON.parse(await IndyBridge.proverGetCredential(credId))
  },

  // TODO Add return flow type.
  // It needs little investigation, because is doesn't seem to be same format as Credential stored in wallet.
  async proverGetCredentialsForProofReq(wh: WalletHandle, proofRequest: ProofRequest) {
    return JSON.parse(await IndyBridge.proverGetCredentialsForProofReq(JSON.stringify(proofRequest), wh))
  },

  async proverCreateProof(
    wh: WalletHandle,
    proofReq: ProofRequest,
    requestedCredentials: RequestedCredentials,
    masterSecretName: MasterSecretId,
    schemas: Schemas,
    credentialDefs: CredentialDefs,
    revStates: RevStates = {}
  ): Promise<Proof> {
    return JSON.parse(
      await IndyBridge.proverCreateProofForRequest(
        JSON.stringify(proofReq),
        JSON.stringify(requestedCredentials),
        masterSecretName,
        JSON.stringify(schemas),
        JSON.stringify(credentialDefs),
        JSON.stringify(revStates),
        wh
      )
    )
  },
}

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
 */

package com.reactlibrary;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.google.gson.Gson;

import org.hyperledger.indy.sdk.IndyException;
import org.hyperledger.indy.sdk.anoncreds.Anoncreds;
import org.hyperledger.indy.sdk.anoncreds.AnoncredsResults;
import org.hyperledger.indy.sdk.crypto.Crypto;
import org.hyperledger.indy.sdk.crypto.CryptoResults;
import org.hyperledger.indy.sdk.did.Did;
import org.hyperledger.indy.sdk.did.DidResults;
import org.hyperledger.indy.sdk.ledger.Ledger;
import org.hyperledger.indy.sdk.ledger.LedgerResults;
import org.hyperledger.indy.sdk.pairwise.Pairwise;
import org.hyperledger.indy.sdk.pool.Pool;
import org.hyperledger.indy.sdk.wallet.Wallet;

import java.util.concurrent.ExecutionException;

public class IndySdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private Pool pool;
    private Wallet wallet;

    public IndySdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "IndySdk";
    }

    @ReactMethod
    public void sampleMethod(String stringArgument, int numberArgument, Promise promise) {
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }

    // wallet

    @ReactMethod
    public void createWallet(String config, String credentials, Promise promise) {
        try {
            Wallet.createWallet(config, credentials).get();
            promise.resolve("Wallet has been created.");
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void openWallet(String config, String credentials, Promise promise) {
        try {
            this.wallet = Wallet.openWallet(config, credentials).get();
            promise.resolve(this.wallet.getWalletHandle());
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void closeWallet(Promise promise) {
        try {
            this.wallet.closeWallet().get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void deleteWallet(String config, String credentials, Promise promise) {
        try {
            Wallet.deleteWallet(config, credentials).get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    // did

    @ReactMethod
    public void createAndStoreMyDid(String didJson, Double wallet, Promise promise) {
        try {
            DidResults.CreateAndStoreMyDidResult createMyDidResult = Did.createAndStoreMyDid(this.wallet, didJson).get();
            String myDid = createMyDidResult.getDid();
            String myVerkey = createMyDidResult.getVerkey();
            WritableArray response = new WritableNativeArray();
            response.pushString(myDid);
            response.pushString(myVerkey);
            promise.resolve(response);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void keyForDid(String did, Promise promise) {
        try {
            String receivedKey = Did.keyForDid(this.pool, this.wallet, did).get();
            promise.resolve(receivedKey);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void keyForLocalDid(String did, Promise promise) {
        try {
            String receivedKey = Did.keyForLocalDid(this.wallet, did).get();
            promise.resolve(receivedKey);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void createPairwise(String theirDid, String myDid, String metadata, Promise promise) {
        try {
            Pairwise.createPairwise(this.wallet, theirDid, myDid, metadata).get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void getPairwise(String theirDid, Promise promise) {
        try {
            String receivedKey = Pairwise.getPairwise(this.wallet, theirDid).get();
            promise.resolve(receivedKey);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    // crypto

    @ReactMethod
    public void cryptoAnonCrypt(String theirKey, String message, Promise promise) {
        try {
            byte[] encryptedData = Crypto.anonCrypt(theirKey, message.getBytes()).get();
            WritableArray result = new WritableNativeArray();
            for (byte b : encryptedData) {
                result.pushInt(b);
            }
            promise.resolve(result);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void cryptoAnonDecrypt(String recipientVk, ReadableArray encryptedMessage, Promise promise) {
        try {
            byte[] encryptedMessageBytes = new byte[encryptedMessage.size()];

            for (int i = 0; i <= encryptedMessage.size(); i++) {
                encryptedMessageBytes[i] = (byte) encryptedMessage.getInt(i);
            }

            byte[] decryptedData = Crypto.anonDecrypt(this.wallet, recipientVk, encryptedMessageBytes).get();
            promise.resolve(decryptedData);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void cryptoAuthCrypt(String senderVk, String recipientVk, String message, Promise promise) {
        try {
            byte[] encryptedData = Crypto.authCrypt(this.wallet, senderVk, recipientVk, message.getBytes()).get();
            WritableArray result = new WritableNativeArray();
            for (byte b : encryptedData) {
                result.pushInt(b);
            }
            promise.resolve(result);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void cryptoAuthDecrypt(String recipientVk, ReadableArray encryptedMessage, Promise promise) {
        try {
            byte[] encryptedMessageBytes = new byte[encryptedMessage.size()];

            for (int i = 0; i < encryptedMessage.size(); i++) {
                encryptedMessageBytes[i] = (byte) encryptedMessage.getInt(i);
            }

            CryptoResults.AuthDecryptResult decryptedResult = Crypto.authDecrypt(this.wallet, recipientVk, encryptedMessageBytes).get();
            String theirKey = decryptedResult.getVerkey();

            WritableArray decryptedData = new WritableNativeArray();
            for (byte b : decryptedResult.getDecryptedMessage()) {
                decryptedData.pushInt(b);
            }

            WritableArray response = new WritableNativeArray();
            response.pushString(theirKey);
            response.pushArray(decryptedData);
            promise.resolve(response);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    // pool

    @ReactMethod
    public void setProtocolVersion(int protocolVersion, Promise promise) {
        try {
            Pool.setProtocolVersion(protocolVersion).get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void createPoolLedgerConfig(String poolName, String poolConfig, Promise promise) {
        try {
            System.out.println(poolConfig);
            Pool.createPoolLedgerConfig(poolName, poolConfig).get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void openPoolLedger(String poolName, String poolConfig, Promise promise) {
        try {
            this.pool = Pool.openPoolLedger(poolName, poolConfig).get();
            promise.resolve(this.pool.getPoolHandle());
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void closePoolLedger(Promise promise) {
        try {
            this.pool.closePoolLedger().get();
            promise.resolve(null);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    // ledger

    @ReactMethod
    public void submitRequest(String requestJson, Promise promise) {
        try {
            String response = Ledger.submitRequest(this.pool, requestJson).get();
            promise.resolve(response);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void buildGetSchemaRequest(String submitterDid, String id, Promise promise) {
        try {
            String request = Ledger.buildGetSchemaRequest(submitterDid, id).get();
            promise.resolve(request);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void parseGetSchemaResponse(String getSchemaResponse, Promise promise) {
        try {
            LedgerResults.ParseResponseResult ledgerResult = Ledger.parseGetSchemaResponse(getSchemaResponse).get();
            WritableArray result = new WritableNativeArray();
            result.pushString(ledgerResult.getId());
            result.pushString(ledgerResult.getObjectJson());
            promise.resolve(result);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void buildGetCredDefRequest(String submitterDid, String id, Promise promise) {
        try {
            String request = Ledger.buildGetCredDefRequest(submitterDid, id).get();
            promise.resolve(request);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void parseGetCredDefResponse(String getCredDefResponse, Promise promise) {
        try {
            LedgerResults.ParseResponseResult ledgerResult = Ledger.parseGetCredDefResponse(getCredDefResponse).get();
            WritableArray result = new WritableNativeArray();
            result.pushString(ledgerResult.getId());
            result.pushString(ledgerResult.getObjectJson());
            promise.resolve(result);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    // anoncreds

    @ReactMethod
    public void proverCreateMasterSecret(String masterSecretId, Promise promise) {
        try {
            String outputMasterSecretId = Anoncreds.proverCreateMasterSecret(this.wallet, masterSecretId).get();
            promise.resolve(outputMasterSecretId);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void proverCreateCredentialReq(String proverDid, String credentialOfferJson, String credentialDefJson, String masterSecretId, Promise promise) {
        try {
            AnoncredsResults.ProverCreateCredentialRequestResult credentialRequestResult = Anoncreds.proverCreateCredentialReq(this.wallet, proverDid, credentialOfferJson, credentialDefJson, masterSecretId).get();
            WritableArray response = new WritableNativeArray();
            response.pushString(credentialRequestResult.getCredentialRequestJson());
            response.pushString(credentialRequestResult.getCredentialRequestMetadataJson());
            promise.resolve(response);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void proverStoreCredential(String credId, String credReqMetadataJson, String credJson, String credDefJson, String revRegDefJson, Promise promise) {
        try {
            String newCredId = Anoncreds.proverStoreCredential(this.wallet, credId, credReqMetadataJson, credJson, credDefJson, revRegDefJson).get();
            promise.resolve(newCredId);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void proverGetCredential(String credId, Promise promise) {
        try {
            String credential = Anoncreds.proverGetCredential(this.wallet, credId).get();
            promise.resolve(credential);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    @ReactMethod
    public void proverGetCredentials(String filter, Promise promise) {
        try {
            String credentials = Anoncreds.proverGetCredentials(this.wallet, filter).get();
            promise.resolve(credentials);
        } catch (Exception e) {
            IndyBridgeRejectResponse rejectResponse = new IndyBridgeRejectResponse(e);
            promise.reject(rejectResponse.getCode(), rejectResponse.toJson(), e);
        }
    }

    class IndyBridgeRejectResponse {
        private String code;
        private String message;

        private IndyBridgeRejectResponse(Throwable e) {
            // Indy bridge exposed API should return consistently only numeric code
            // When we don't get IndyException and Indy SDK error code we return zero as default
            String code = "0";

            if (e instanceof ExecutionException) {
                Throwable cause = e.getCause();
                if (cause instanceof IndyException) {
                    IndyException indyException = (IndyException) cause;
                    code = String.valueOf(indyException.getSdkErrorCode());
                }
            }

            String message = e.getMessage();

            this.code = code;
            this.message = message;
        }

        public String getCode() {
            return code;
        }

        public String getMessage() {
            return message;
        }

        public String toJson() {
            Gson gson = new Gson();
            return gson.toJson(this);
        }
    }
}

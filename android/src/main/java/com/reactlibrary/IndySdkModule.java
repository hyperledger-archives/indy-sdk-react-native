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

import com.google.gson.Gson;

import org.hyperledger.indy.sdk.IndyException;
import org.hyperledger.indy.sdk.wallet.Wallet;

import java.util.concurrent.ExecutionException;

public class IndySdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
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

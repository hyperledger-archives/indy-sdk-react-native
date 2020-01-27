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

import { NativeModules } from 'react-native'

const { IndySdk } = NativeModules

export default {
  createWallet(config, credentials) {
    return IndySdk.createWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  openWallet(config, credentials) {
    return IndySdk.openWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  closeWallet(wh) {
    if (Platform.OS === 'ios') {
      return IndySdk.closeWallet(wh)
    }
    return IndySdk.closeWallet()
  },

  deleteWallet(config, credentials) {
    return IndySdk.deleteWallet(JSON.stringify(config), JSON.stringify(credentials))
  },

  sampleMethod(stringArgument, numberArgument) {
    return IndySdk.sampleMethod(stringArgument, numberArgument)
  },
}

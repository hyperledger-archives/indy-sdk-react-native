# React Native Indy SDK

React Native Indy SDK wrapper.

## Installation

with npm:
`$ npm install indy-sdk-react-native --save`

with Yarn:
`$ yarn add indy-sdk-react-native`

Link (for React Native lower than 0.60)

`$ react-native link indy-sdk-react-native`

## Android

See https://github.com/TimoGlastra/ExampleRnIndySDK for an example android react native project that follows this tutorial.

### 1. Set min SDK version

Make sure there is a min. SDK version setup in `android/build.gradle`:

```groovy
buildscript {
    ext {
        ...
        minSdkVersion = 21
        ...
    }
}
```

### 2. Add Sovrin Maven repository

Add Sovrin Maven repository into `android/build.gradle`:

```groovy
allprojects {
    repositories {
        ...
        maven {
            url 'https://repo.sovrin.org/repository/maven-public'
        }
        ...
    }
}
```

### 3. Add JNA library dependency

Add to `android/app/build.gradle`:

```groovy
dependencies {
    // ...
    implementation 'net.java.dev.jna:jna:5.2.0'

    // ...
}
```

### 4. Add Android libindy binaries

Download Android libindy binaries and copy them into `android/app/src/main/jniLibs`.

1. Create `android/app/src/main/jniLibs` directory in your project
2. Create subdirectories `arm64-v8a`, `armeabi-v7a`, `x86` and `x86_64` inside `android/app/src/main/jniLibs`.
3. Download the required libindy binaries for your release-channel and version
   - with `stable` channel and version `1.16.0` base url will be https://repo.sovrin.org/android/libindy/stable/1.16.0/
   - download the binaries for `arm64`, `armv7`, `x86` and `x86_64`, e.g.:
     - `libindy_android_arm64_1.16.0.zip`
     - `libindy_android_armv7_1.16.0.zip`
     - `libindy_android_x86_1.16.0.zip`
     - `libindy_android_x86_64_1.16.0.zip`
4. Extract all downloaded ZIP files and copy `libindy.so` files to corresponding `jniLibs` directory
   - `libindy_arm64/lib/libindy.so` to `jniLibs/arm64-v8a/libindy.so`
   - `libindy_armv7/lib/libindy.so` to `jniLibs/armeabi-v7a/libindy.so`
   - `libindy_x86/lib/libindy.so` to `jniLibs/x86/libindy.so`
   - `libindy_x86_64/lib/libindy.so` to `jniLibs/x86_64/libindy.so`
5. Download the required JNA binaries from the [JNA GitHub repo](https://github.com/java-native-access/jna)
   - libindy version 1.16.0 works with version 5.5.0 of JNA. In this case the base url is: https://github.com/java-native-access/jna/tree/5.5.0/lib/native
   - download the binaries for `aarch64`, `armv7`, `x86`, `x86-64`, e.g.:
     - `android-aarch64.jar`
     - `android-armv7.jar`
     - `android-x86-64.jar`
     - `android-x86.jar`
6. Extract all downloaded JAR files and copy `libjnidispatch.so` to corresponding `jniLibs` directory
   - You can extract the `.so` file from the jar using the `jar` command. e.g. `jar xf android-x86.jar`
   - `libjnidispatch.so` from `android-aarch64.jar` to `jniLibs/arm64-v8a/libjnidispatch.so`
   - `libjnidispatch.so` from `android-armv7.jar` to `jniLibs/armeabi-v7a/libjnidispatch.so`
   - `libjnidispatch.so` from `android-x86.jar` to `jniLibs/x86/libjnidispatch.so`
   - `libjnidispatch.so` from `android-x86-64.jar` to `jniLibs/x86_64/libjnidispatch.so`

### 5. Load indy library

Add the following to `MainActivity.java`:

```java

//...

import android.os.Bundle;
import android.system.ErrnoException;
import android.system.Os;

public class MainActivity extends ReactActivity {
  //...

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    try {
      Os.setenv("EXTERNAL_STORAGE", getExternalFilesDir(null).getAbsolutePath(), true);
      System.loadLibrary("indy");
    } catch (ErrnoException e) {
      e.printStackTrace();
    }
  }
}
```

### 6. Hermes

Hermes is required in order to perform ledger operations using the Indy SDK.

> For more info, see [this Indy-SDK issue](https://github.com/hyperledger/indy-sdk/issues/2346#issuecomment-841000640).

#### React Native >= 0.70.0

Hermes is enabled by default

#### React Native 0.62.0 - 0.69.5

Add or adjust the following in the `android/app/build.gradle` to:

```gradle
project.ext.react = [
    enableHermes: true,  // clean and rebuild if changing
]
```

#### React Native <= 0.61.5

Hermes is not required for older versions of React Native


## iOS

1. Install CocoaPods dependencies:

```
pod install --project-directory=ios/
```

2. Add the following line to the start of your Podfile (`ios/Podfile`):

```
source 'https://github.com/hyperledger/indy-sdk-react-native'
```

3. Configure Bitcode to `no` in both the project and targets

4. Set `Build Libraries for Distribution` to `yes` in both the project and targets

> This is required due to mismatching Swift versions between the Indy SDK and the application, as described in this [Stackoverflow Answer](https://stackoverflow.com/questions/58654714/module-compiled-with-swift-5-1-cannot-be-imported-by-the-swift-5-1-2-compiler/63305234#63305234)

5. iOS Simulators are currently not supported and should be disabled

## Usage

```javascript
import indy from 'indy-sdk-react-native'

await indy.createWallet({ id: 'wallet-123' }, { key: 'key' })
```

You can see example project here https://github.com/jakubkoci/UseReactNativeIndySdk/. It currently shows only usage on Android.

## Known Errors

### Add setup of external storage permissions (Android)

I found an error with permission while calling `createWallet` when I was testing this package:

```
2020-01-27 16:25:02.300 9955-10044/com.usereactnativeindysdk E/log_panics: thread 'unnamed' panicked at 'called `Result::unwrap()` on an `Err` value: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }': libcore/result.rs:945
```

Modify `onCreate` method in `MainActivity` of your project where you want to use this library in a following way:

```java
public class MainActivity extends ReactActivity {
  ...
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    File externalFilesDir = getExternalFilesDir(null);
    String path = externalFilesDir.getAbsolutePath();
    System.out.println("externalFilesDir=" + path);

    try {
      Os.setenv("EXTERNAL_STORAGE", path, true);
    } catch (ErrnoException e) {
      e.printStackTrace();
    }
    ...
  }
  ...
}
```

This should resolve the issue with permissions.

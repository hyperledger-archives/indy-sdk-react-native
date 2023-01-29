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

### 3. Download Android libindy binaries

Download Android `.aar` library from Release 0.2.2 [android-indy-sdk-release-device-1.15.0.aar](https://github.com/hyperledger/indy-sdk-react-native/releases/download/0.2.2/android-indy-sdk-release-device-1.15.0.aar) and copy it into `android/app/libs`.

### 4. Update Gradle dependencies

Add `.aar` to array of file dependencies and JNA library to `android/app/build.gradle`:

```groovy
dependencies {
    // ...

    implementation fileTree(dir: "libs", include: ["*.jar", "*.aar"])
    implementation 'net.java.dev.jna:jna:5.6.0'

    // ...
}
```

I also needed to the gradle file `android/app/build.gradle` the following because I was getting duplicated class error:

```groovy
android {
  // ...
  packagingOptions {
      pickFirst '**/lib/arm64-v8a/libc++_shared.so'
      pickFirst '**/lib/arm64-v8a/libfbjni.so'
      pickFirst '**/lib/armeabi-v7a/libc++_shared.so'
      pickFirst '**/lib/armeabi-v7a/libfbjni.so'
      pickFirst '**/lib/x86/libc++_shared.so'
      pickFirst '**/lib/x86/libfbjni.so'
      pickFirst '**/lib/x86_64/libc++_shared.so'
      pickFirst '**/lib/x86_64/libfbjni.so'
  }
}
```

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

1. Add the following lines to the start of your Podfile (`ios/Podfile`).

If a custom `source` is defined we also need to define the default source (which is implicit if no source is specified), explicitly:

```
source 'https://github.com/hyperledger/indy-sdk-react-native'
source 'https://cdn.cocoapods.org'
```

2. Install the Latest CocoaPods dependencies:

```
cd ios
pod install
pod update Indy
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

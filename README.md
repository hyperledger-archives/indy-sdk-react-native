# React Native Indy SDK

React Native Indy SDK wrapper.

## Installation

with npm:
`$ npm install rn-indy-sdk --save`

with Yarn:
`$ yarn add rn-indy-sdk` 

Link (for React Native lower than 0.60)

`$ react-native link rn-indy-sdk`

## Android

Make sure there is a min. SDK version setup:

```groovy
buildscript {
    ext {
        ...
        minSdkVersion = 21
        ...
    }
}
```

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

Download Android libindy binaries and copy them into `android/app/src/main/jniLibs`.

## iOS

Add `Indy.framework` as dependency into your project. Beware that the library needs to be compiled with the same version of Swift as your project.

React Native wrapper for iOS is written in Swift so you need to Create briding header. In Xcode app menu go to File -> New -> File... Select Swift File from dialog window and click Next and Finish. Xcode shoud ask you "Would you like to configure an Objective-C briding header?" then select Create Bridinging Header.


## Usage
```javascript
import indy from 'rn-indy-sdk';

await indy.createWallet({ id: 'wallet-123' }, { key: 'key' });

```

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

# rn-indy-sdk


## Getting started

`$ npm install rn-indy-sdk --save`

## Linking (for React Native lower than 0.60)

`$ react-native link rn-indy-sdk`

## Usage
```javascript
import IndySdk from 'rn-indy-sdk';

// TODO: What to do with the module?
IndySdk;
```

## Add setup of external storage permissions

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
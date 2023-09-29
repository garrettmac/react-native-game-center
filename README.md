
# react-native-game-center

## Getting started

`$ npm install react-native-game-center --save`

### Mostly automatic installation

`$ react-native link react-native-game-center`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-game-center` and add `RNGameCenter.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNGameCenter.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNGameCenterPackage;` to the imports at the top of the file
  - Add `new RNGameCenterPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-game-center'
  	project(':react-native-game-center').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-game-center/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-game-center')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNGameCenter.sln` in `node_modules/react-native-game-center/windows/RNGameCenter.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Game.Center.RNGameCenter;` to the usings at the top of the file
  - Add `new RNGameCenterPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNGameCenter from 'react-native-game-center';

// TODO: What to do with the module?
RNGameCenter;
```
  
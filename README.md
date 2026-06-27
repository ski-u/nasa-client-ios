# NASA Client iOS

[![CI](https://github.com/ski-u/nasa-client-ios/actions/workflows/tests.yml/badge.svg)](https://github.com/ski-u/nasa-client-app/actions/workflows/tests.yml)

> [!note]
> A personal iOS app project for learning purposes :apple:

## API

- [NASA APIs](https://api.nasa.gov)

## Features

### Browsing Astronomy Picture of the Day

- API:  https://github.com/nasa/apod-api

![](./Screenshots/apod.gif)

### Accesibility Support

- Light / Dark mode
- Dynamic Type
- Localization (EN, JA)
- Contents translation (EN → JA) using [Translation framework](https://developer.apple.com/documentation/translation/)

## Project Architecture

- [pointfreeco/swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture) based architecture
- Modularized using Swift Package Manager

## Getting Started

1. Clone the repo
2. Open `NASAClient.xcodeproj`
3. Choose `NASAClient` scheme
4. Run the app

## Environment

- Xcode 26.6
- Swift 6.3

## Tech stack

- [cybozu/LicenseList](https://github.com/cybozu/LicenseList)
- [kishikawakatsumi/KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [konomae/swift-local-date](https://github.com/konomae/swift-local-date)
- [pointfreeco/swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [swiftlang/swift-format](https://github.com/swiftlang/swift-format)

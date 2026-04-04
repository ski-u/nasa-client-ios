# NASAClientApp

[![CI](https://github.com/ski-u/nasa-client-app/actions/workflows/tests.yml/badge.svg)](https://github.com/ski-u/nasa-client-app/actions/workflows/tests.yml)

> [!note]
> This is an experimental project to learn iOS app development :apple:

## API: [NASA APIs](https://api.nasa.gov)

### Astronomy Picture of the Day

- Official website: https://apod.nasa.gov/apod/astropix.html
- GitHub repo: https://github.com/nasa/apod-api

## Features

### See Astronomy Pictures

| Today's picture | History |
| -- | -- |
| ![](./Screenshots/astronomy-picture-today.gif) | ![](./Screenshots/astronomy-picture-history.gif) |

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

- Xcode 26.4
- Swift 6.2

## Tech stack

- [cybozu/LicenseList](https://github.com/cybozu/LicenseList)
- [kishikawakatsumi/KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [konomae/swift-local-date](https://github.com/konomae/swift-local-date)
- [pointfreeco/swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [swiftlang/swift-format](https://github.com/swiftlang/swift-format)

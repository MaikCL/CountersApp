# Cornershop iOS Development Test

## About the Architecture

This app was built using an MVI architecture and since the architecture is based on reactive programming, I decided to use Combine in the project.
To get more information about the architecture, I wrote a little readme explaining it in another project I did [PKDex-iOS](https://github.com/mzapatae/PKDex-iOS)

For that the app was separated into 5 modules.
The CounterKit module is the main module that has all the actions and states to manipulate the counters. This module is imported into the other remaining modules (CounterListKit, NewCounterKit) that are only the respective presentation layer for the listing and for inserting new counters.

The detail of the modules:

- **APIsKit**: Module with the definition of the APIs that can be used in the rest of the main modules.
- **DesignKit**: Module that containt Color definitions, some reusable Views and the rest of stuff that can define an DesignSystem
- **CounterKit**: Core module with all the operations and states to manipulate Counters
- **CounterListKit**: Module with the Presentation Layer to display the CounterList
- **NewCounterKit**: Module with the Presentation Layer to display the Screen to Add a new Counter.

## Open the project

To Open and Compile the App you must open the file `Counters.xcworkspace`. This does not prevent the packages from being opened individually, but the workspace will load all the packages and the main project.

## Compile the project

Open the file `Modules/APIsKit/Sources/APIs/CounterAPI.swift` and change the value of the `baseURL` with the IP of the node server.

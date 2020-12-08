# todolist

An Etherium Blockchain Todo list application with a Flutter frontend.

## Dependencies

-  ### Flutter

The fontend application is written in Dart using the Flutter framework.

Install it [here](https://flutter.dev/docs/get-started/install)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

- ### Ganache

Gancache is a "One-Click Blockchain". With it, you can quickly fire up a personal Ethereum blockchain which you can use to run tests, execute commands, and inspect state while controlling how the chain operates.

Install it [here](https://www.trufflesuite.com/ganache)

- ### Truffle

Truffle is a world class development environment, testing framework and asset pipeline for blockchains using the Ethereum Virtual Machine (EVM), aiming to make life as a developer easier. We will be using it to deploy our smart contract to our local blockchain.

- ## Getting Started

After cloning, `cd` to the root of the project directory. Run an npm install to install the npm `dotenv` module. This will allow you to pipe in your host address and port number using a `.env` file. You'll need to create this file in the root of your project.

To the file add the following and you'll be good to go.

```
HOST=YOUR_HOST_ADDRESS/IP
PORT=YOUR_HOST_PORT
```

You can get this information from Ganache. After installing, open it and click the "Quickstart" option. This will deploy your local Etherium Blockchain and set up a few accounts with 100eth each. You can find the `HOST` and `PORT` information in the settings menu under the `SERVER` tab.

Under the `WORKSPACE` tab, you'll want to point Ganache to your `truffle-config.js` file in the root of your project. Click "ADD PROJECT" and select the file.

At this point you can run `truffle migrate` in a terminal at the root of the project to delpoy your smart contracts. Any further deploying will require the `--reset` flag, as smart contracts cannot be mutated, only replaced.

Now, on to the Flutter configuration. This project has been verified working on Android, iOS, and MacOS. More to come. The logic relies on environment variables. When executing `flutter run` you'll need to pass in a few flags.

`flutter run --no-sound-null-safety --dart-define=RPC_URL=[RPC url and port] --dart-define=WS_URL=ws://[Web socket address and port] --dart-define=PRIVATE_KEY=[Your private key from the first account listed in Ganache]`
            


<img src="https://www.activeledger.io/wp-content/uploads/2018/09/Asset-23.png" alt="Activeledger" width="500"/>


# Activeledger SDK-IOS

![](https://github.com/activeledger/SDK-IOS/blob/master/assets/appVideo.gif)


## SDK Dev Instruction

Use the ActiveLedger SDK interface to Use the SDK.

## Initialise the SDK

```Swift
let activeledgerSDK = ActiveledgerSDK(http: "http", baseURL: "testnet-uk.activeledger.io", port: "5260")
```

## Generate KeyPair

```Swift
activeledgerSDK?.generateKeys(type: encryptionSelected, name: "ASL")
```

## Fetching Public Key in PEM

```Swift
let publicKey = activeledgerSDK?.getPublicKeyPEM()
```

## Fetching Private Key in PEM

```Swift
let privateKey = activeledgerSDK?.getPrivateKeyPEM()
```

## Oboard KeyPair

Onboarding a KeyPair will give an Single Observable in return. Use RxSwift to subscribe to it.

```Swift
let response: Single<JSON> = activeledgerSDK?.onBoardKeys()
```

## Server Sent Event

Server Sent Events can be subscribed by giving the URL. Function return RxSwift Observable that can be subscribed (Example given below). Events are connected automatically and is disconnected when disposing Observable. Dont forget to dispose Observable to avoid memory leaks. 
There are Three events :
1- Open
2- Message
3- Complete

Properties of event object might change with respect to differnt types which can be accessed by "type" property of the event.
In case in which event is disconnect unexpecteldly, User can reconnect using 

```Swift
activeledgerSDK?.reConnectEvent()
```
Example: 

```Swift
activeledgerSDK?.subscribeToEvent(url: URL(string: "http://testnet-uk.activeledger.io:5261/api/activity/subscribe")!)
.subscribe(
                         onNext: { data in
                           print("---event---")
                           print(data.type)

                         },
                         onError: { error in
                           print(error)
                         },
                         onCompleted: {
                           print("Completed")
                         },
                         onDisposed: {
                           print("Disposed")
                           self.activeledgerSDK?.disconnectEvent()
                         }
                     ).disposed(by: bag)
```

## Executing a Transaction

Execute method takes a transaction and will give an Single Observable in return with response in JSON format. Use RxSwiftto subscribe to it.

```Swift
let request: Single<JSON> = executeTransaction(transaction: transaction)

request
.subscribe(onSuccess: { response in

    print("---success response---")
    print(response)
    
}, onError: { error in
    print(error)
}).disposed(by: bag)

```


## License

---

This project is licensed under the [MIT](https://github.com/activeledger/SDK-IOS/blob/master/LICENSE) License


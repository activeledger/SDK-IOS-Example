<img src="https://www.activeledger.io/wp-content/uploads/2018/09/Asset-23.png" alt="Activeledger" width="500"/>


# Activeledger SDK-IOS


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

Server Sent Events can be subscribed by giving the protocol, ip and port. All the functional URLs can be found in Utility/ApiURL.
User can create  their own ServerEventListener and observe the events or can pass null and Observe the LiveData variable "SSEUtil.getInstance().eventLiveData".

```Swift
ActiveLedgerSDK.getInstance().subscribeToEvent(protocol, ip, port, url, null/ServerEventListener);
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


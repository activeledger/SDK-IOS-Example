<img src="https://www.activeledger.io/wp-content/uploads/2018/09/Asset-23.png" alt="Activeledger" width="500"/>


# Activeledger SDK-Android

To use the Android SDK please Add it in your root build.gradle at the end of repositories:

```Java
allprojects {
	repositories {
		maven { url 'https://jitpack.io' }
	}
}
```

Add the dependency

```Java
dependencies {
	implementation 'com.github.activeledger:SDK-Android:Tag'
}
```

For Maven:

```Java
<repositories>
	<repository>
		<id>jitpack.io</id>
		<url>https://jitpack.io</url>
	</repository>
</repositories>
```

Add the dependency

```Java
<dependency>
	<groupId>com.github.activeledger</groupId>
	<artifactId>SDK-Android</artifactId>
	<version>Tag</version>
</dependency>
```

### NOTE: Please update the Tag : 0.1.3

## SDK Dev Instruction

Use the ActiveLedger SDK interface to Use the SDK.

## Initialise the SDK

```Java
ActiveLedgerSDK.getInstance().initSDK(this,"protocol","URL","port");
Example:
ActiveLedgerSDK.getInstance().initSDK(this,"http","testnet-uk.activeledger.io","5260");
```

## Generate KeyPair

Generating a KeyPair will give an Observable in return. User RxAndroid to subscribe to the Obserable.

```Java
Observable<KeyPair> keyPair = ActiveLedgerSDK.getInstance().generateAndSetKeyPair(KeyType,SaveKeysToFile);
Example:
Observable<KeyPair> keyPair = ActiveLedgerSDK.getInstance().generateAndSetKeyPair(keyType,true);
```

## Oboard KeyPair

Onboarding a KeyPair will give an Observable in return. User RxAndroid to subscribe to the Obserable.

```Java
Observable<String> response = ActiveLedgerSDK.getInstance().onBoardKeys(KeyPair, "KeyName");
Example:
ActiveLedgerSDK.getInstance().onBoardKeys(keyPair, "ActiveLedgerAwesomeKey");
```

## Creating and Signing Transaction

Transactions can be created using Transactions class in the SDK. User can create complete transaction or just the $tx Object and SDK will create the complete transaction. User can also create Labeled Transaction using the example below. 
$tx is a JSONObject that can be created by folowing Activeledger Documentation.

```Java
JSONObject transaction = Transactions.createLabeledTransaction($tx);
```

## Server Sent Event

Server Sent Events can be subscribed by giving the protocol, ip and port. All the functional URLs can be found in Utility/ApiURL.
User can create  their own ServerEventListener and observe the events or can pass null and Observe the LiveData variable "SSEUtil.getInstance().eventLiveData".

```Java
ActiveLedgerSDK.getInstance().subscribeToEvent(protocol, ip, port, url, null/ServerEventListener);
```

## Executing a Transaction

Execute method takes a transaction and will give an Observable in return with response in String format. User RxAndroid to subscribe to the Obserable.

```Java
Observable<String>  respinse =  ActiveLedgerSDK.getInstance().executeTransaction(String transactionJson);
```


## License

---

This project is licensed under the [MIT](https://github.com/activeledger/SDK-Android/blob/master/LICENSE) License


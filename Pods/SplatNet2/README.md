# SplatNet2

SplatNet2 is the framework to generate iksm_session using internal and external API to get JSON from SplatNet2.

## Installation

### Requirements
* iOS13.0+
* Xcode 11+

### CocoaPods

```ruby
pod 'SplatNet2'
```

### SPM(Swift Package Manager)

```swift
dependencies: [
    .package(url: "https://github.com/tkgstrator/SplatNet2.git")
]
```

## Usage

### session_token_code
Generating iksm_session, we must need `session_token_code` and `session_token_code_verifier` given by random byte strings. Moreover, `session_token_code` is provided by `oauth_url` like [this](https://accounts.nintendo.com/connect/1.0.0/authorize?state=DthLWOg54YPRnkPpxhY0aMyxEfSdmRplaOtIlIJimBxnAhbM&redirect_uri=npf71b963c1b7b6d119://auth&client_id=71b963c1b7b6d119&scope=openid+user+user.birthday+user.mii+user.screenName&response_type=session_token_code&session_token_code_challenge=8PlJorbqc1oUmynjgtICD3JzrNd3oez9kTeEYBCsXls&session_token_code_challenge_method=S256&theme=login_form).

[This](https://salmonia.mydns.jp) website could help you to get them. They(`auth_url` and `auth_code_verifier`) are reusable, you don't have to access twice.

### get iksm_session

```swift
import SplatNet2
import SwiftyJSON

do {
    var response: JSON = JSON()
    let session_token_code = "YOUR SESSION TOKEN CODE"
    let session_token_code_verifier = "YOUR SESSION TOKEN CODE VERIFIER"
    response = try SplatNet2.getSessionToken(session_token_code, session_token_code_verifier)
    let session_token = response["session_token"].stringValue
    response = try SplatNet2.genIksmSession(session_token)
} catch (error) {
    // Error handling
}
```

### regenerate iksm_session

Session token does not have the expiration, so it takes less time to regenarate iksm_session  by session_token.

```swift
import SplatNet2
import SwiftyJSON

do {
    let session_token = "YOUR SESSION TOKEN"
    response = try SplatNet2.genIksmSession(session_token)
} catch (error) {
    // Error handling
}
```

### nickname and icons

Nintendo provides the API to get nickname and icons by nsaid(this is named as *nsa-data-id/pid/principal id*).

```swift
import SplatNet2
import SwiftyJSON

do {
    let iksm_session = "YOUR IKSM SESSION"
    let nsaids: [String] = "NSAID's ARRAY"
    response = try SplatNet2.getPlayerNickname(nsaids, iksm_session)
} catch (error) {
    // Error handling
}
```

## Error handling

SplatNet2 might return Error with below format in case Nintendo change API method.

```swift
enum APIError: Error {
    case Response(String, String)
}
```

* 9400 Invalid request in getting Splatoon Access Token
* 9002 Invalid/Expired Iksm Session (*Need to regenerate*)
* 9403 Invalid token in getting Splatoon Token
* 9406 OAuth session was Unauthorized (Nintendo API change *X-ProductVersion?*)
* 9427 Upgrade Required (*Nintendo Switch Online app update*)
* 9999 Unkonwn Error


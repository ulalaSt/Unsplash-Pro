


import Foundation

class EndPoint {

    //Network Defaults
    static let base = "https://unsplash.com/"
    static let baseUrl = "https://api.unsplash.com/"
    static let clientIdParameter = "client_id=puCF08Cyqxnl1o8Ensgw7qRuJ-lXrJYBUeW2_OG5mOg"
    static let clientSecret = "gFrEdgN6KkVuLroKmmjy3xuKTzqcyxPWJjv-vTkN7yA"
    static let redirectURI = "myFirstScheme://"
    static let authenticationScope = "public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"

    //User Defaults
    static let currentUserAccessToken = UserDefaults.standard.string(forKey: DefaultKeys.currentUserAccessTokenKey)
    static let currentUserAccessScope = UserDefaults.standard.string(forKey: DefaultKeys.currentUserAccessScopeKey)
    static let currentUserName = UserDefaults.standard.string(forKey: DefaultKeys.userFirstName)
}

///   Extra clientID for only cases of Rate Limit Exceed in Unsplash API. Replace it only in case of Rate Limit Exceed, and Only after User Logs Out.
//static let clientIdParameter = "client_id=HtdyZmUmNvBK7oTHX6QF0JB5DpTwPZMQWVibA-smS4o"
//static let clientSecret = "N3QuCAYz4R3Cx5W_ZfB6dLgHi_O9n5ey3efyoFtfR7o"

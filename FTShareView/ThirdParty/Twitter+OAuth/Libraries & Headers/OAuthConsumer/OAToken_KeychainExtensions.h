//
//  OAToken_KeychainExtensions.h
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 04/04/08.
//  Copyright 2008 Fuerte International. All rights reserved.
//

#import "OAToken.h"

#import <Security/Security.h>

@interface OAToken (OAToken_KeychainExtensions)

- (id)initWithKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider;
- (int)storeInDefaultKeychainWithAppName:(NSString *)name serviceProviderName:(NSString *)provider;
- (int)storeInKeychain:(SecKeychainRef)keychain appName:(NSString *)name serviceProviderName:(NSString *)provider;

@end

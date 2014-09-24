//
//  KeeperSDK.m
//
//  Created by Arthur Walasek on 9/22/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "KeeperSDK.h"
#import <MobileCoreServices/MobileCoreServices.h>

// Generic Password Extension Constants
// App Extension Actions
NSString *const kUTTypeAppExtensionFindLoginAction = @"org.appextension.find-login-action";
NSString *const kUTTypeAppExtensionSaveLoginAction = @"org.appextension.save-login-action";
NSString *const kUTTypeAppExtensionChangePasswordAction = @"org.appextension.change-password-action";
NSString *const kUTTypeAppExtensionFillWebViewAction = @"org.appextension.fill-webview-action";

// Login Dictionary keys
NSString *const AppExtensionURLStringKey = @"url_string";
NSString *const AppExtensionUsernameKey = @"username";
NSString *const AppExtensionPasswordKey = @"password";
NSString *const AppExtensionTitleKey = @"login_title";
NSString *const AppExtensionNotesKey = @"notes";
NSString *const AppExtensionSectionTitleKey = @"section_title";
NSString *const AppExtensionFieldsKey = @"fields";
NSString *const AppExtensionReturnedFieldsKey = @"returned_fields";
NSString *const AppExtensionOldPasswordKey = @"old_password";
NSString *const AppExtensionPasswordGereratorOptionsKey = @"password_generator_options";

// WebView Dictionary keys
//NSString *const AppExtensionWebViewPageFillScript = @"fillScript";
//NSString *const AppExtensionWebViewPageDetails = @"pageDetails";

// Password Generator options
NSString *const AppExtensionGeneratedPasswordMinLengthKey = @"password_min_length";
NSString *const AppExtensionGeneratedPasswordMaxLengthKey = @"password_max_length";

// Errors
NSString *const AppExtensionErrorDomain = @"Keeper Extension";
NSInteger const AppExtensionErrorCodeCancelledByUser = 0;
NSInteger const AppExtensionErrorCodeAPINotAvailable = 1;
NSInteger const AppExtensionErrorCodeFailedToContactExtension = 2;
NSInteger const AppExtensionErrorCodeFailedToLoadItemProviderData = 3;
NSInteger const AppExtensionErrorCodeCollectFieldsScriptFailed = 4;
NSInteger const AppExtensionErrorCodeFillFieldsScriptFailed = 5;
NSInteger const AppExtensionErrorCodeUnexpectedData = 6;

@implementation KeeperSDK

#pragma mark - Public Methods

+ (KeeperSDK *)sharedExtension
{
    static dispatch_once_t onceToken;
    static KeeperSDK *__sharedExtension;
    
    dispatch_once(&onceToken, ^{
        __sharedExtension = [KeeperSDK new];
    });
    
    return __sharedExtension;
}


- (BOOL)isSystemAppExtensionAPIAvailable {
#ifdef __IPHONE_8_0
    return NSClassFromString(@"NSExtensionItem") != nil;
#else
    return NO;
#endif
}

- (BOOL)isAppExtensionAvailable {
    if ([self isSystemAppExtensionAPIAvailable]) {
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"org-appextension-feature-password-management://"]];
    }
    
    return NO;
}

- (void)findLoginForURLString:(NSString *)URLString forViewController:(UIViewController *)viewController sender:(id)sender completion:(void (^)(NSDictionary *loginDictionary, NSError *error))completion
{
    NSAssert(URLString != nil, @"URLString must not be nil");
    NSAssert(viewController != nil, @"viewController must not be nil");
    
    if (![self isSystemAppExtensionAPIAvailable]) {
        NSLog(@"Failed to findLoginForURLString, system API is not available");
        if (completion) {
            completion(nil, [KeeperSDK systemAppExtensionAPINotAvailableError]);
        }
        
        return;
    }
    
#ifdef __IPHONE_8_0
    NSDictionary *item = @{ AppExtensionURLStringKey: URLString };
    
    __weak typeof (self) miniMe = self;
    
    UIActivityViewController *activityViewController = [self activityViewControllerForItem:item viewController:viewController sender:sender typeIdentifier:kUTTypeAppExtensionFindLoginAction];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (returnedItems.count == 0) {
            NSError *error = nil;
            if (activityError) {
                NSLog(@"Failed to findLoginForURLString: %@", activityError);
                error = [KeeperSDK failedToContactExtensionErrorWithActivityError:activityError];
            }
            else {
                error = [KeeperSDK extensionCancelledByUserError];
            }
            
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        [strongMe processExtensionItem:returnedItems[0] completion:^(NSDictionary *loginDictionary, NSError *error) {
            if (completion) {
                completion(loginDictionary, error);
            }
        }];
    };
    
    [viewController presentViewController:activityViewController animated:YES completion:nil];
#endif
}

- (void)storeLoginForURLString:(NSString *)URLString loginDetails:(NSDictionary *)loginDetailsDict passwordGenerationOptions:(NSDictionary *)passwordGenerationOptions forViewController:(UIViewController *)viewController sender:(id)sender completion:(void (^)(NSDictionary *, NSError *))completion;
{
    NSAssert(URLString != nil, @"URLString must not be nil");
    NSAssert(loginDetailsDict != nil, @"loginDetailsDict must not be nil");
    NSAssert(viewController != nil, @"viewController must not be nil");
    
    if (![self isSystemAppExtensionAPIAvailable]) {
        NSLog(@"Failed to storeLoginForURLString, system API is not available");
        if (completion) {
            completion(nil, [KeeperSDK systemAppExtensionAPINotAvailableError]);
        }
        
        return;
    }
    
    
#ifdef __IPHONE_8_0
    NSMutableDictionary *newLoginAttributesDict = [NSMutableDictionary new];
    newLoginAttributesDict[AppExtensionURLStringKey] = URLString;
    [newLoginAttributesDict addEntriesFromDictionary:loginDetailsDict];
    if (passwordGenerationOptions.count > 0) {
        newLoginAttributesDict[AppExtensionPasswordGereratorOptionsKey] = passwordGenerationOptions;
    }
    
    __weak typeof (self) miniMe = self;
    
    UIActivityViewController *activityViewController = [self activityViewControllerForItem:newLoginAttributesDict viewController:viewController sender:sender typeIdentifier:kUTTypeAppExtensionSaveLoginAction];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (returnedItems.count == 0) {
            NSError *error = nil;
            if (activityError) {
                NSLog(@"Failed to storeLoginForURLString: %@", activityError);
                error = [KeeperSDK failedToContactExtensionErrorWithActivityError:activityError];
            }
            else {
                error = [KeeperSDK extensionCancelledByUserError];
            }
            
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        [strongMe processExtensionItem:returnedItems[0] completion:^(NSDictionary *loginDictionary, NSError *error) {
            if (completion) {
                completion(loginDictionary, error);
            }
        }];
    };
    
    [viewController presentViewController:activityViewController animated:YES completion:nil];
#endif
}

- (void)changePasswordForLoginForURLString:(NSString *)URLString loginDetails:(NSDictionary *)loginDetailsDict passwordGenerationOptions:(NSDictionary *)passwordGenerationOptions forViewController:(UIViewController *)viewController sender:(id)sender completion:(void (^)(NSDictionary *loginDict, NSError *error))completion
{
    NSAssert(URLString != nil, @"URLString must not be nil");
    NSAssert(viewController != nil, @"viewController must not be nil");
    
    if (![self isSystemAppExtensionAPIAvailable]) {
        NSLog(@"Failed to changePasswordForLoginWithUsername, system API is not available");
        if (completion) {
            completion(nil, [KeeperSDK systemAppExtensionAPINotAvailableError]);
        }
        
        return;
    }
    
#ifdef __IPHONE_8_0
    NSMutableDictionary *item = [NSMutableDictionary new];
    item[AppExtensionURLStringKey] = URLString;
    [item addEntriesFromDictionary:loginDetailsDict];
    if (passwordGenerationOptions.count > 0) {
        item[AppExtensionPasswordGereratorOptionsKey] = passwordGenerationOptions;
    }
    
    __weak typeof (self) miniMe = self;
    UIActivityViewController *activityViewController = [self activityViewControllerForItem:item viewController:viewController sender:sender typeIdentifier:kUTTypeAppExtensionChangePasswordAction];
    
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (returnedItems.count == 0) {
            NSError *error = nil;
            if (activityError) {
                NSLog(@"Failed to changePasswordForLoginWithUsername: %@", activityError);
                error = [KeeperSDK failedToContactExtensionErrorWithActivityError:activityError];
            }
            else {
                error = [KeeperSDK extensionCancelledByUserError];
            }
            
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        [strongMe processExtensionItem:returnedItems[0] completion:^(NSDictionary *loginDictionary, NSError *error) {
            if (completion) {
                completion(loginDictionary, error);
            }
        }];
    };
    
    [viewController presentViewController:activityViewController animated:YES completion:nil];
#endif
}

#pragma mark - Helpers

- (UIActivityViewController *)activityViewControllerForItem:(NSDictionary *)item viewController:(UIViewController*)viewController sender:(id)sender typeIdentifier:(NSString *)typeIdentifier {
#ifdef __IPHONE_8_0
    
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:typeIdentifier];
    
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    extensionItem.attachments = @[ itemProvider ];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ extensionItem ]  applicationActivities:nil];
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        controller.popoverPresentationController.barButtonItem = sender;
    }
    else if ([sender isKindOfClass:[UIView class]]) {
        controller.popoverPresentationController.sourceView = [sender superview];
        controller.popoverPresentationController.sourceRect = [sender frame];
    }
    else {
        NSLog(@"sender can be nil on iPhone");
    }
    
    return controller;
#else
    return nil;
#endif
}


#pragma mark - Errors

+ (NSError *)systemAppExtensionAPINotAvailableError {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"App Extension API is not available is this version of iOS", @"Keeper App Extension Error Message") };
    return [NSError errorWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeAPINotAvailable userInfo:userInfo];
}


+ (NSError *)extensionCancelledByUserError {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"Generic Password Extension was cancelled by the user", @"Keeper App Extension Error Message") };
    return [NSError errorWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeCancelledByUser userInfo:userInfo];
}

+ (NSError *)failedToContactExtensionErrorWithActivityError:(NSError *)activityError {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Failed to contacting the Generic Password App Extension", @"Keeper App Extension Error Message");
    if (activityError) {
        userInfo[NSUnderlyingErrorKey] = activityError;
    }
    
    return [NSError errorWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeFailedToContactExtension userInfo:userInfo];
}

+ (NSError *)failedToCollectFieldsErrorWithUnderlyingError:(NSError *)underlyingError {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Failed to execute script that collects web page information", @"Keeper App Extension Error Message");
    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    
    return [NSError errorWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeCollectFieldsScriptFailed userInfo:userInfo];
}

+ (NSError *)failedToFillFieldsErrorWithLocalizedErrorMessage:(NSString *)errorMessage underlyingError:(NSError *)underlyingError {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (errorMessage) {
        userInfo[NSLocalizedDescriptionKey] = errorMessage;
    }
    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    
    return [NSError errorWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeFillFieldsScriptFailed userInfo:userInfo];
}

+ (NSError *)failedToLoadItemProviderDataErrorWithUnderlyingError:(NSError *)underlyingError {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Failed to parse information returned by Generic Password App Extension", @"Keeper App Extension Error Message");
    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    
    return [[NSError alloc] initWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeFailedToLoadItemProviderData userInfo:userInfo];
}

#pragma mark - App Extension ItemProvider Callback

- (void)processExtensionItem:(NSExtensionItem *)extensionItem completion:(void (^)(NSDictionary *loginDictionary, NSError *error))completion {
    if (extensionItem.attachments.count == 0) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Unexpected data returned by Generic Password App Extension: extension item had no attachments." };
        NSError *error = [[NSError alloc] initWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeUnexpectedData userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    NSItemProvider *itemProvider = extensionItem.attachments[0];
    if (![itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Unexpected data returned by Generic Password App Extension: extension item attachment does not conform to kUTTypePropertyList type identifier" };
        NSError *error = [[NSError alloc] initWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeUnexpectedData userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    
    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *loginDictionary, NSError *itemProviderError)
     {
         NSError *error = nil;
         if (!loginDictionary) {
             NSLog(@"Failed to loadItemForTypeIdentifier: %@", itemProviderError);
             error = [KeeperSDK failedToLoadItemProviderDataErrorWithUnderlyingError:itemProviderError];
         }
         
         if (completion) {
             if ([NSThread isMainThread]) {
                 completion(loginDictionary, error);
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completion(loginDictionary, error);
                 });
             }
         }
     }];
}

@end

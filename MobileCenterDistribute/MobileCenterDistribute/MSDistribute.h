#import "MSDistributeDelegate.h"
#import "MSServiceAbstract.h"

/**
 * Mobile Center Distribute service.
 */
@interface MSDistribute : MSServiceAbstract

/**
 * Set the Distribute delegate
 *
 * @param delegate The Distribute delegate.
 */
+ (void)setDelegate:(id<MSDistributeDelegate>)delegate;

/**
 * Notify SDK with a user action to handle the update.
 */
+ (void)notifyUserUpdateAction:(MSUserUpdateAction)action;

/**
 * Change the URL that will be used for generic update related tasks.
 *
 * @param apiUrl The new URL.
 */
+ (void)setApiUrl:(NSString *)apiUrl;

/**
 * Change the base URL that is used to install update.
 *
 * @param installUrl The new URL.
 */
+ (void)setInstallUrl:(NSString *)installUrl;

/**
 * Process URL request for the service.
 *
 * @param url  The url with parameters.
 *
 * @discussion Place this method call into app delegate openUrl method.
 */
+ (void)openUrl:(NSURL *)url;

@end

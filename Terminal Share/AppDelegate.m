// AppDelegate.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <ScriptingBridge/ScriptingBridge.h>

#import "AppDelegate.h"

static NSString * NSSharingServiceNameFromDefaults(NSUserDefaults *defaults) {
    NSString *service = [[defaults objectForKey:@"service"] lowercaseString];
    
    if ([service isEqualToString:@"twitter"]) {
        return NSSharingServiceNamePostOnTwitter;
    } else if ([service isEqualToString:@"sinaweibo"]) {
        return NSSharingServiceNamePostOnSinaWeibo;
    } else if ([service isEqualToString:@"email"]) {
        return NSSharingServiceNameComposeEmail;
    } else if ([service isEqualToString:@"message"]) {
        return NSSharingServiceNameComposeMessage;
    } else if ([service isEqualToString:@"airdrop"]) {
        return NSSharingServiceNameSendViaAirDrop;
    } else if ([service isEqualToString:@"readinglist"]) {
        return NSSharingServiceNameAddToSafariReadingList;
    } else if ([service isEqualToString:@"iphoto"]) {
        return NSSharingServiceNameAddToIPhoto;
    } else if ([service isEqualToString:@"aperature"]) {
        return NSSharingServiceNameAddToAperture;
    } else if ([service isEqualToString:@"facebook"]) {
        return NSSharingServiceNamePostOnFacebook;
    } else if ([service isEqualToString:@"flickr"]) {
        return NSSharingServiceNamePostImageOnFlickr;
    } else if ([service isEqualToString:@"vimeo"]) {
        return NSSharingServiceNamePostVideoOnVimeo;
    } else if ([service isEqualToString:@"youku"]) {
        return NSSharingServiceNamePostVideoOnYouku;
    } else if ([service isEqualToString:@"tudou"]) {
        return NSSharingServiceNamePostVideoOnTudou;
    }
    
    return nil;
}

static NSArray * NSSharingServiceItemsFromDefaults(NSUserDefaults *defaults) {
    NSMutableArray *mutableItems = [NSMutableArray array];
    if ([defaults objectForKey:@"text"]) {
        [mutableItems addObject:[defaults objectForKey:@"text"]];
    }
    
    if ([defaults objectForKey:@"image"]) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:[defaults objectForKey:@"image"]];
        if (image) {
            [mutableItems addObject:image];
        }
    }
    
    if ([defaults objectForKey:@"url"]) {
        NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"url"]];
        if (url) {
            [mutableItems addObject:url];
        }
    }
    
    if ([defaults objectForKey:@"video"]) {
        NSURL *videoURL = [NSURL fileURLWithPath:[defaults objectForKey:@"video"]];
        if (videoURL) {
            [mutableItems addObject:videoURL];
        }
    }
    
    return mutableItems;
}

@interface AppDelegate () <NSSharingServiceDelegate>
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *sharingServiceName = NSSharingServiceNameFromDefaults(defaults);
    if (!sharingServiceName) {
        exit(1);
    }
    
    NSSharingService *sharingService = [NSSharingService sharingServiceNamed:sharingServiceName];
    sharingService.delegate = self;
    [sharingService performWithItems:NSSharingServiceItemsFromDefaults(defaults)];
}

#pragma mark - ScriptingBridge

- (BOOL)activateAppWithBundleID:(NSString *)bundleID {
    id app = [SBApplication applicationWithBundleIdentifier:bundleID];
    if (app) {
        [app activate];
        
        return YES;
    } else {
        NSLog(@"Unable to find an application with the specified bundle indentifier.");
        
        return NO;
    }
}

#pragma mark - NSSharingServiceDelegate

- (void)sharingService:(NSSharingService *)sharingService
         didShareItems:(NSArray *)items
{
    exit(0);
}

- (void)sharingService:(NSSharingService *)sharingService
   didFailToShareItems:(NSArray *)items
                 error:(NSError *)error
{
    exit(1);
}

@end

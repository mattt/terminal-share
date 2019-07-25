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

static void PrintHelpBanner() {
    NSMutableArray *mutableLines = [NSMutableArray array];
    NSMutableDictionary *mutableArguments = [NSMutableDictionary dictionary];
    mutableArguments[@"service"] = @"A short string corresponding to the name of a particular NSSharingService to be used. Available values:\n\t\t\t\ttwitter, sinaweibo, email, message, airdrop, iphoto, aperture, facebook, flickr, vimeo, youku, tudou\n";
    mutableArguments[@"text"] = @"Text to be shared (optional)";
    mutableArguments[@"image"] = @"Image to be shared (optional)";
    mutableArguments[@"video"] = @"Video to be shared (optional)";
    mutableArguments[@"url"] = @"URL to be shared (optional)";
    
    [mutableLines addObjectsFromArray:@[@"terminal-share", @"", @"A command-line interface to the Mac OS X Sharing Services", @""]];
    
    [mutableLines addObjectsFromArray:@[@"Usage:", @"\t$ terminal-share -service NAME [-text text] [-image /path/to/image] [-video /path/to/video] [-url \"http://example.com\"]", @""]];
    
    [mutableLines addObjectsFromArray:@[@"Example:", @"\t$terminal-share -service twitter -text \"This was shared from the command-line, courtesy of terminal-share, by @mattt\" -url \"https://github.com/mattt/terminal-share\"", @""]];

    
    [mutableLines addObject:@"Arguments:"];
    [@[@"service", @"text", @"image", @"video", @"url"] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        NSString *argument = [key stringByPaddingToLength:8 withString:@" " startingAtIndex:0];
        NSString *description = [mutableArguments objectForKey:key];
        [mutableLines addObject:[NSString stringWithFormat:@"\t-%@\t\t%@", argument, description]];
    }];
    [mutableLines addObject:@""];

    [mutableLines addObjectsFromArray:@[@"Author:", @"\tMattt Thompson <m@mattt.me>", @""]];
    [mutableLines addObjectsFromArray:@[@"Website:", @"\thttps://github.com/mattt", @""]];

    [mutableLines enumerateObjectsUsingBlock:^(id line, NSUInteger idx, BOOL *stop) {
        printf("%s\n", [line UTF8String]);
    }];
}

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
    } else if ([service isEqualToString:@"aperture"]) {
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
        PrintHelpBanner();
        exit(EXIT_FAILURE);
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
    exit(EXIT_SUCCESS);
}

- (void)sharingService:(NSSharingService *)sharingService
   didFailToShareItems:(NSArray *)items
                 error:(NSError *)error
{
    exit(EXIT_FAILURE);
}

@end

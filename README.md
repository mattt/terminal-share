terminal-share
--------------

**Mac OS X Sharing Services... As A Service**

Mac OS X 10.8 Mountain Lion introduced [built-in sharing](http://www.apple.com/osx/whats-new/features.html#builtin-sharing). Access to this system-level feature is provided through [`NSSharingService`](http://developer.apple.com/library/Mac/#documentation/AppKit/Reference/NSSharingService_Class/Reference/Reference.html).

`terminal-share` extends access to these APIs by proxying through a simple command-line application. Normally, Apple would provide such a Unix command-line interface through a Foundation Tool.

## Ruby

```ruby
require 'terminal-share'

TerminalShare.share(:twitter, text: "This was shared from the command-line, courtesy of terminal-share, by @mattt", url: "https://github.com/mattt/terminal-share")
```

![Screenshot](https://raw.github.com/mattt/terminal-share/screenshots/terminal-share-screenshot.png)

## Command Line

```
$ terminal-share -service NAME [-text text] [-image /path/to/image] [-video /path/to/video] [-url "http://example.com"]
```

### Arguments

- `service`: (__Required__) A short string corresponding to the name of a particular `NSSharingService` to be used. Available values:
    - `twitter` - `NSSharingServiceNamePostOnTwitter`
    - `sinaweibo` - `NSSharingServiceNamePostOnSinaWeibo`
    - `email` - `NSSharingServiceNameComposeEmail`
    - `message` - `NSSharingServiceNameComposeMessage`
    - `airdrop` - `NSSharingServiceNameSendViaAirDrop`
    - `readinglist` - `NSSharingServiceNameAddToSafariReadingList`
    - `iphoto` - `NSSharingServiceNameAddToIPhoto`
    - `aperature` - `NSSharingServiceNameAddToAperture`
    - `facebook` - `NSSharingServiceNamePostOnFacebook`
    - `flickr` - `NSSharingServiceNamePostImageOnFlickr`
    - `vimeo` - `NSSharingServiceNamePostVideoOnVimeo`
    - `youku` - `NSSharingServiceNamePostVideoOnYouku`
    - `tudou` - `NSSharingServiceNamePostVideoOnTudou`
- `text`: (_optional_) Text to be shared.
- `image`: (_optional_) File path to an image to be shared.
- `video`: (_optional_) File path to a video to be shared.
- `url`: (_optional_) URL to be shared.

> Not all services support sharing of all types of content. See the [NSSharingService Documentation](http://developer.apple.com/library/Mac/#documentation/AppKit/Reference/NSSharingService_Class/Reference/Reference.html) for additional guidelines.

### Example

```
$ terminal-share -service twitter -text "This was shared from the command-line, courtesy of terminal-share, by @mattt" -url "https://github.com/mattt/terminal-share"
```

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## Credit

Thanks to [Eloy Durán](https://github.com/alloy) for his work on [`terminal-notifier`](https://github.com/alloy/terminal-notifier), which was used as inspiration and a guideline for how to use the Script Bridge APIs.

## License

terminal-share is available under the MIT license. See the LICENSE file for more info.

> This library is no longer being maintained.

# terminal-share

**macOS Sharing Services... as a Service**

Mac OS X 10.8 Mountain Lion introduced built-in sharing as a system-level feature
with programmatic access provided via the
[`NSSharingService` APIs](https://developer.apple.com/documentation/appkit/nssharingservice).

`terminal-share` extends access to these APIs
by proxying through a simple command-line application.

## Installation

Install `terminal-share` by running the following command from Terminal:

```
$ gem install terminal-share
```

This will also install the `terminal-share` executable.

```ruby
require 'terminal-share'

TerminalShare.share(:twitter, text: "This was shared from the command-line, courtesy of terminal-share, by @mattt", url: "https://github.com/mattt/terminal-share")
```

![Screenshot](https://raw.github.com/mattt/terminal-share/screenshots/terminal-share-screenshot.png)

## Command Line

```
$ terminal-share -service NAME              \
                [-text text]                \
                [-image /path/to/image]     \
                [-video /path/to/video]     \
                [-url "http://example.com"]
```

### Arguments

- `service`: (**Required**) A short string corresponding to the name of a particular `NSSharingService` to be used. Available values:
  - `twitter` - `NSSharingServiceNamePostOnTwitter`
  - `sinaweibo` - `NSSharingServiceNamePostOnSinaWeibo`
  - `email` - `NSSharingServiceNameComposeEmail`
  - `message` - `NSSharingServiceNameComposeMessage`
  - `airdrop` - `NSSharingServiceNameSendViaAirDrop`
  - `readinglist` - `NSSharingServiceNameAddToSafariReadingList`
  - `iphoto` - `NSSharingServiceNameAddToIPhoto`
  - `aperture` - `NSSharingServiceNameAddToAperture`
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
$ terminal-share -service twitter \
                 -text "This was shared from the command-line,  \
                        courtesy of terminal-share, by @mattt"  \
                 -url "https://github.com/mattt/terminal-share"
```

## Creator

Mattt ([@mattt](https://twitter.com/mattt))

## Credit

Thanks to [Eloy Durán](https://github.com/alloy) for his work on 
[`terminal-notifier`](https://github.com/alloy/terminal-notifier), 
which provides a great example of how to use the Script Bridge APIs.

## License

terminal-share is available under the MIT license. 
See the LICENSE file for more info.

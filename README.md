# Re-signing a built iOS app

Investigating bugs that a client of your framework is experiencing can be significantly easier if you're able to
reproduce the issue locally in a debugger. As many clients are rightfully reluctant to share their source code,
debugging a prebuilt binary is the next best step. This repository contains a collection of scripts that can assist
with re-signing a prebuilt iOS application using your own signing identity and provisioning profile. This allows
you to install and run the application on your device, and even to replace your own framework in the app bundle
with a your own copy containing debugging code.

## Usage

Starting with Test.ipa, containing a prebuilt version of Test.app provided by a user:

1. `unzip Test.ipa && mv Payload Test`
2. `cd Test`
3. `prepare.rb Test.app 38F637AQG5 nz.net.bdash.Test.3P`
4. `sign.rb Test.app "iPhone Developer: Mark Rowe (RSYL4QFV9U)"`

After modifying Test.app in any way (e.g., replacing a dynamic framework), re-run step 4.

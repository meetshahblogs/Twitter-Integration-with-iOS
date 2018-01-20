# Twitter Integration with iOS

`Twitter integration for iOS` is a demo iOS application writter in Objective-C demonstrating how to integrate Twitter API for iOS into iPhone application. 

For more information please check out the video tutorial on [YouTube](https://www.youtube.com/watch?v=jLfxcSnfrP8&t=5s)

In this demo project we have covered following three Twitter APIs,
1. Authenticate user using their Twitter account
2. Compose Tweet from the app and post it on Twitter timeline
3. Use REST API to fetch tweets from user's timeline and show in the app in TableView format.

## Usage
Step-1
*   `Property List.plist` is the file that contains twitter consumer key and application secret keys. Once you create your application on Twitter apps dashboard, edit this file and paste the keys Twitter generated for your application.

Stp-2
* `info.plist` file has URL Scheme for Twitter call-back Url that constain value `twitter-<consumerkey>`. Replace consumer-key here with the one Twitter created for your application.



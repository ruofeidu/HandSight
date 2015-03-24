# HandSight

In this project, we designed an iPad prototype for evaluating using finger-mouted camera with vibration & feedback system to enable reading of printed text for the blind. The corresponding paper(s) are published in [ECCV Workshop on Assistive Computer Vision and Robotics (ACVR). 2014] [1]. 

As P3 reports in our user study for ACVR 2014:

> “It puts the blind reading on equal footing with rest of the society, because I am reading from the same reading material that others read, not just braille, which is limited to blind people only”.

In ACVR paper, we introduce the preliminary design of a novel vision-augmented touch system called HandSight intended to support activities of daily living (ADLs) by sensing and feeding back non-tactile information about the physical world as it is touched. Though we are interested in supporting a range of ADL applications, here we focus specifically on reading printed text. We discuss our vision for HandSight, describe its current implementation and results from an initial performance analysis of finger-based text scanning. We then present a user study with four visually impaired participants (three blind) exploring how to continuously guide a user’s finger across text using three feedback conditions (haptic, audio, and both). Though preliminary, our results show that participants valued the ability to access printed material, and that, in contrast to previous findings, audio finger guidance may result in the best reading performance

### Features
Though I only have less than 1 year of iOS programming experience, my code may be benefitial to you in the following aspects

  - Dynamic layout of UI controls
  - Bluetooth Low Energy connection 
  - Text-to-speech with variant speed on the go
  - Two-column text layout
  - Logging of touch events
  - Reading / loading files
  - Design patterns

Using third-party libraries, you may find the following code examples:
  
  - HTTP request for sending and receiving message via [AFNetworking]
  - Playing sound using [SoundManager]

### Version
1.0.1

### Tech

HandSights uses a number of open source projects to work properly:

* [SoundManager] - Playing sound and music in iOS or Mac apps.
* [BLEMini] - BLE Mini is a small, certified BLE development board for makers to do their innovative projects. It can be used for BLE development using TI CC254x SDK.
* [AFNetworking] - AFNetworking is a delightful networking library for iOS and Mac OS X. It's built on top of the Foundation URL Loading System, extending the powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use.

### Todo's

 - Interface for restraunt menus

License
----

[MIT License]

Contact
----
  - Ruofei Du 
  - me (at) duruofei (dot) com

**Free Software, Hell Yeah!**


[1]:http://www.duruofei.com/Public/papers/ruofei_eccv2014.pdf
[BLEMini]:https://github.com/RedBearLab/BLEMini
[SoundManager]:https://github.com/nicklockwood/SoundManager
[MIT License]:http://en.wikipedia.org/wiki/MIT_License
[AFNetworking]:https://github.com/AFNetworking/AFNetworking

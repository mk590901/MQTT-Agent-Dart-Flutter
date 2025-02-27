# MQTT-Agent-Dart-Flutter

The repository contains a demo application on flutter, which demonstrates the capabilities of the previously implemented MQTT client as a data source capable of sending data to the cloud from time to time.

## Introduction

The __MQTT Agent__ application, using the previously created __MQTT Client__ (https://github.com/mk590901/MQTT-Client-Dart-Flutter repository), is a prototype of a compact module for transmitting data to the cloud ☁️, episodically generated by application.

## Target

For example, it would be good to add the ability to quickly transfer and save __HSM schemes__ and __generated code__ files on the desktop to the graphical editor. After all, this is where this code is used to create applications. Of course, can use a regular USB cable to transfer data from your phone to a computer or e-mail, but if you can make it a little more convenient for the user, then why not do it? Naturally, need to write an application for the desktop to receive data. When writing, can use the same MQTT client in a console application on dart.

The execution of data transfer operations can be interrupted due to external errors at any of the five steps, but the state machine allows you to simplify the implementation of the proposed approach. And this approach is extremely simple: in case of successful completion of the current step, you need to send an event to activate the next action through the broker object.

## State machine

It is shown below. This is the same state machine as in the previous project https://github.com/mk590901/MQTT-Client-Dart-Flutter repository. Moreover, the __threaded code__ is the same. But the actual transfer functions have changed slightly.

![output1](https://github.com/user-attachments/assets/cd3d2a50-0259-40bb-bf5e-1d0e6aedb74e)

## How the application works

I'll immediately note that the GUI does not differ in any special delights. There is a __GO__ button that you need to press. After pressing, a list of completed steps appears. And that's all. The first movie also shows the error situations that occur when there is no network.

The second movie demonstrates receiving data generated by a new application, an application created earlier (https://github.com/mk590901/MQTT-Client-Dart-Flutter).

## Movie I. Sender

https://github.com/user-attachments/assets/e40e97fc-adc3-4754-a90c-b8e463fdd1a0

## Movie II. Receiver

https://github.com/user-attachments/assets/a2045ef7-81a4-4392-9303-920be7fd0662




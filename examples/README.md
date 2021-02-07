# Lumberjack::Dispatcher::EventSource examples

These are examples demonstrating how `Lumberjack::Dispatcher::EventSource` might be used.


## [cro-tick-log](cro-tick-log)

This shows how to setup and use the evensource dispatcher in a Cro based web appplication.

You will need to install Cro::HTTP to run this:

    zef install --/test Cro::HTTP

running the program will start an HTTP server on port 7798.  If you visit http://127.0.0.1:7798/
you will get a page to which will be added random log messages at random levels.  This should
work in most modern browsers.  The raw event stream is at http://127.0.0.1:7798/log .

Obviously in a real world situation you will be sending the log messages from various parts of
your application where the components do the `Lumberjack::Logger` role.

## [index.html](index.html)

This is the HTML served by the above, it shows how easy it is to consume the event stream in
a web page, basically a few lines of Javascript, though there are probably React or Angular
components that do this.

## [node-client](node-client)

A simple client fot the event stream for Node.js, it may be useful for testing.



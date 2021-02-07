# Lumberjack::Dispatcher::EventSource

A Dispatcher for Lumberjack that emits the log messages as server sent events

![Build Status](https://github.com/jonathanstowe/Lumberjack-Dispatcher-EventSource/workflows/CI/badge.svg)

## Synopsis

    use Lumberjack;
    use Lumberjack::Dispatcher::EventSource;
    use Cro::HTTP::Router;
    use Cro::HTTP::Server;

    my $dispatcher = Lumberjack::Dispatcher::EventSource.new

    Lumberjack.dispatchers.append: $dispatcher;


    my $app = route {
        get -> {
            content 'text/event-stream', $dispatcher.Supply;
        }
    };

    my Cro::Service $log = Cro::HTTP::Server.new(:host<localhost>, :port<7798>, application => $app);

    $log.start;

    react whenever signal(SIGINT) { $log.stop; exit; }

There is a slightly more comprehensive example in the [examples](examples) directory.

## Description

This is a [Lumberjack::Dispatcher](https://github.com/jonathanstowe/Lumberjack/blob/master/Documentation.md#lumberjackdispatcher) implementation that emits the log messages as JSON (as formatted by `Lumberjack::Message::JSON`,) on a supply in the format of [Server Sent Events](https://www.w3.org/TR/eventsource/). The `Supply` can be passed as a response to a web toolkit that supports chunked encoding such as `Cro` or `Crust`.

This may be useful if you want to expose your logging to the web or to some log archiver or something.

The exact format of the JSON emitted is documented by [Lumberjack::Message::JSON](https://github.com/jonathanstowe/Lumberjack-Message-JSON)

## Installation

Assuming you have a working Rakudo installation then you can install this with *zef* :

    zef install Lumberjack::Dispatcher::EventSource

## Support

This is a very simple module, really just the composition of some existing things, so it's most likely that if there are bugs they are in `EventSource::Server` or `Lumberjack::Message::JSON`
However please feel free to report any issues/suggestions/whatever at [Github](https://github.com/jonathanstowe/Lumberjack-Dispatcher-EventSource/issues).

## Licence and Copyright

This is free software, please see the [LICENCE](LICENCE) file in the distribution for more details.

© Jonathan Stowe 2021-


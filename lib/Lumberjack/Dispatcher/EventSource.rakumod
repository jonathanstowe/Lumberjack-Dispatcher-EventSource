use v6;

=begin pod

=head1 NAME

Lumberjack::Dispatcher::EventSource - dispatch Lumberjack messages to server sent events

=head1 SYNOPSIS

=begin code

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




=end code

=head1 DESCRIPTION

This is a C<Lumberjack::Dispatcher> implementation that emits the log messages as JSON (as formatted by
C<Lumberjack::Message::JSON>,) on a supply in the format of L<Server Sent Events|https://www.w3.org/TR/eventsource/>.
The C<Supply> can be passed as a response to a web toolkit that supports chunked encoding such as C<Cro> or C<Crust>.

This may be useful if you want to expose your logging to the web or to some log archover or something.

The exact format of the JSON emitted is documented by L<Lumberjack::Message::JSON|https://github.com/jonathanstowe/Lumberjack-Message-JSON>

=head1 METHODS

=head2 method new

    method new()

This takes the C<classes> and C<levels> parameters that are provided for by C<Lumberjack::Dispatcher> and constraint the messages that are handled but has no other useful parameters.


=head2 attribute Supply

This is the C<Supply> to which the messages will be emitted. In some places this will be used as a coercion so the object itself can be passed.

=end pod

use Lumberjack;
use Lumberjack::Message::JSON;
use EventSource::Server;

class Lumberjack::Dispatcher::EventSource does Lumberjack::Dispatcher {
    has Supply   $.Supply;

    has EventSource::Server $!eventsource = EventSource::Server.new;

    method Supply( --> Supply ) {
        $!Supply //= $!eventsource.out-supply;
    }

    method log(Lumberjack::Message $message) {
        if $message !~~ Lumberjack::Message::JSON {
            $message does Lumberjack::Message::JSON;
        }
        $!eventsource.supplier.emit($message.to-json(:!pretty));
    }
}
# vim: expandtab shiftwidth=4 ft=raku

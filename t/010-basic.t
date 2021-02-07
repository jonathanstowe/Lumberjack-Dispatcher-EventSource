#!/usr/bin/env raku

use Test;

use Lumberjack::Dispatcher::EventSource;
use Lumberjack;
use Lumberjack::Message::JSON;

constant JSONMessage = (Lumberjack::Message but Lumberjack::Message::JSON);

class Loggy does Lumberjack::Logger {
}

my $loggy = Loggy.new;

my $dispatcher = Lumberjack::Dispatcher::EventSource.new;

Lumberjack.dispatchers.append: $dispatcher;

my $messages = $dispatcher.Supply.Channel;

$loggy.log-info("Info level message");

my $m = $messages.receive;
isa-ok $m, utf8;

ok my $decoded = $m.decode, "can decode it";

ok my $payload = $decoded.subst(/'data: '/, ''), "has the EvenSource data:" ;

my $ljm;

lives-ok {
    $ljm = JSONMessage.from-json($payload);
}, "reconstruct the message";

is $ljm.message, "Info level message", "got the right message";
is $ljm.level, Lumberjack::Info, "with the right level";

done-testing()
# vim: ft=raku

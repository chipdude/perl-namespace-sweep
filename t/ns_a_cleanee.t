#!/usr/bin/env perl

# This test file is from the namespace::autoclean distribution (t/cleanee.t)

use strict;
use warnings;
use Test::More tests => 3;

{
    package My::Cleaner;
    use namespace::sweep ();

    sub import {
        namespace::sweep->import(
            -cleanee => scalar(caller),
            -also => 'blast',
        );
        *{Foo::boom} = sub { 'boom' };
    }
}

{
    package Foo;
    BEGIN { My::Cleaner->import } # use My::Cleaner tries to load it from disk
    sub explode { 'explode' }
    sub blast { 'blast' }
}

ok( Foo->can('explode'), 'locally defined methods still work');
ok(!Foo->can('boom'), 'imported functions removed');
ok(!Foo->can('blast'), '-also methods removed');


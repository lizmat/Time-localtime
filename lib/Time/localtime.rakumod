use v6.*;

our $tm_sec   is export(:FIELDS);
our $tm_min   is export(:FIELDS);
our $tm_hour  is export(:FIELDS);
our $tm_mday  is export(:FIELDS);
our $tm_mon   is export(:FIELDS);
our $tm_year  is export(:FIELDS);
our $tm_wday  is export(:FIELDS);
our $tm_yday  is export(:FIELDS);
our $tm_isdst is export(:FIELDS);

class Time::localtime:ver<0.0.6>:auth<zef:lizmat> {
    has Int $.sec;
    has Int $.min;
    has Int $.hour;
    has Int $.mday;
    has Int $.mon;
    has Int $.year;
    has Int $.wday;
    has Int $.yday;
    has Int $.isdst;
}

sub populate(@fields) {
    if @fields {
        Time::localtime.new(
          sec   => ($tm_sec   = @fields[0]),
          min   => ($tm_min   = @fields[1]),
          hour  => ($tm_hour  = @fields[2]),
          mday  => ($tm_mday  = @fields[3]),
          mon   => ($tm_mon   = @fields[4]),
          year  => ($tm_year  = @fields[5]),
          wday  => ($tm_wday  = @fields[6]),
          yday  => ($tm_yday  = @fields[7]),
          isdst => ($tm_isdst = @fields[8]),
        )
    }
    else {
        $tm_sec = $tm_min = $tm_hour = $tm_mday = $tm_mon = $tm_year =
        $tm_wday = $tm_yday = $tm_isdst = Int;
        Nil
    }
}

my sub localtime(Int() $time = time) is export(:DEFAULT:FIELDS) {
    use P5localtime:ver<0.0.9>:auth<zef:lizmat>;
    populate(localtime($time))
}

my sub ctime(Int() $time = time) is export(:DEFAULT:FIELDS) {
    use NativeCall;
    my sub get-ctime(int64 is rw --> Str) is native is symbol<ctime> {*}

    my int64 $epoch = $time;  # must be a separate definition
    get-ctime($epoch).chomp
}

=begin pod

=head1 NAME

Raku port of Perl's Time::localtime module

=head1 SYNOPSIS

    use Time::localtime;
    printf "Year is %d\n", localtime.year + 1900;

    $now = ctime();

    use Time::localtime;
    $date_string = ctime($file.IO.modified);

=head1 DESCRIPTION

This module tries to mimic the behaviour of Perl's C<Time::gmtime> module
as closely as possible in the Raku Programming Language.

This module's default exports a C<localtime> and C<ctime> functions. The
C<localtime> function returns a "Time::localtime" object.  This object has
methods that return the similarly named structure field name from the C's
tm structure from time.h; namely sec, min, hour, mday, mon, year, wday, yday,
and isdst.

You may also import all the structure fields directly into your namespace as
regular variables using the :FIELDS import tag. (Note that this still exports
the functions.) Access these fields as variables named with a preceding tm_.
Thus, C<$group_obj.year> corresponds to C<$tm_year> if you import the fields.

The C<ctime> function provides a way of getting at the scalar sense of the
C<localtime> function in Perl.

=head1 PORTING CAVEATS

This module depends on the availability of POSIX semantics.  This is
generally not available on Windows, so this module will probably not work
on Windows.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Time-localtime . Comments
and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018, 2019, 2020, 2021 Elizabeth Mattijsen

Re-imagined from Perl as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4

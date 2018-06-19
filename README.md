# Ruby hidden explicit_bzero() function exported.

Ruby's C implementation has its explicit_bzero() function but it never
make the function available from the ruby land.  I'll do that for you.

## Provided functionality

This library provides one method named `String#explicit_bzero`.  Which
is of course not very ruby-ish, I know, but best describes what is
going on.

```ruby
string.explicit_bzero() # => self
```

Cleanse the receiver.  Raises `FrozenError` if the receiver is frozen.

## Q&As

### This library fails to load on my machine.  Why?

Your ruby is too old.  All Ruby since 2015 has this function.

### I want this also possible on JRuby!

I suspect that's possible.  Not sure how though.  Pull request much
appreciated.

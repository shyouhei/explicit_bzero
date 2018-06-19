#! /your/favourite/path/to/ruby
# -*- mode: ruby; coding: utf-8; indent-tabs-mode: nil; ruby-indent-level: 2 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Copyright (c) 2018 Urabe, Shyouhei
#
# Permission is hereby granted, free of  charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction,  including without limitation the rights
# to use,  copy, modify,  merge, publish,  distribute, sublicense,  and/or sell
# copies  of the  Software,  and to  permit  persons to  whom  the Software  is
# furnished to do so, subject to the following conditions:
#
#       The above copyright notice and this permission notice shall be
#       included in all copies or substantial portions of the Software.
#
# THE SOFTWARE  IS PROVIDED "AS IS",  WITHOUT WARRANTY OF ANY  KIND, EXPRESS OR
# IMPLIED,  INCLUDING BUT  NOT LIMITED  TO THE  WARRANTIES OF  MERCHANTABILITY,
# FITNESS FOR A  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT SHALL THE
# AUTHORS  OR COPYRIGHT  HOLDERS  BE LIABLE  FOR ANY  CLAIM,  DAMAGES OR  OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class String

  begin
    gem 'fiddle' if RUBY_VERSION >= '2.3.0'
    require 'fiddle'
    libc = Fiddle.dlopen nil
    name = 'explicit_bzero'
    ptr  = libc.sym name
  rescue Fiddle::DLError
    begin
      gem 'openssl' if RUBY_VERSION >= '2.3.0'
      require 'openssl'      
      name = 'OPENSSL_cleanse'
      ptr  = libc.sym name
    rescue Fiddle::DLError
      raise <<-"end".strip
        No memory cleansing routine found.
        You must have one for recent ruby (starting 2015).
        Try a newer version.
      end
    end
  end

  exc  = (defined? FrozenError) ? FrozenError : RuntimeError
  func = Fiddle::Function.new ptr, \
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T], \
    Fiddle::TYPE_VOID,
    name: name

  define_method :explicit_bzero do
    raise exc, "can't modify frozen string" if frozen?
    ptr = Fiddle::Pointer.to_ptr self
    func.call ptr, bytesize
    return self
  end
end

# AesKeeper

A database safe encryption using AES 256 CBC.  Key required, Salt optional.  Returns encrypted String and IV,
or you can call **.to_s** to receive the encrypted data as one String. Decrypt will accept either form of the
 { encrypted: '', iv: '' } pair or the String result.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aes_keeper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aes_keeper

## Usage

With encryption and iv result separate:
```ruby
cipher = AesKeeper.new(key: 'some really good 32 character long key for encryption! ^_^')
result = cipher.encrypt("apples")
# => {:encrypted=>"K1E/a75/3zxNKCTXJFJZaVe8jjeHFQG+Cv1Lxntz3oM=\n", :iv=>"uQozeVXYhaeK7Rvh1na6kA==\n"}
cipher.decrypt(result)
# => "apples" 
```

With encryption and iv result combined:
```ruby
cipher = AesKeeper.new(key: 'some really good 32 character long key for encryption! ^_^')
result = cipher.encrypt("apples").to_s
# => "xPbb+kVIROlA5YHvSaKsYcCobgBz/TQHpJ5wP9lAuBQ=\n:WIaGiOhjFBRBVJReiA2aTA==\n"
cipher.decrypt(result)
# => "apples" 
```

You can specify a Salt as well:
```ruby
AesKeeper.new(
  key: 'some really good 32 character long key for encryption! ^_^',
  salt: 'asdfqwerty'
)
```

## Contributing

This code can be refactored and tested.  Otherwise I consider this project feature complete.  It's designed
with assumptions for its implementation and it's met those requirements.

1. Fork it ( https://github.com/[my-github-username]/aes_keeper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright (c) 2015 Daniel P. Clark

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
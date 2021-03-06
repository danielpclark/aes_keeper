require 'minitest_helper'

describe AESKeeper::AESKeeperPure do
  let(:uuid)    { SecureRandom.uuid }
  let(:encrypt1){AESKeeper::AESKeeperPure.new key: "asdfghjklqwertyuiopzxcvbnm1234567890"}
  let(:encrypt2){AESKeeper::AESKeeperPure.new key: "asdfghjklqwertyuiopzxcvbnm1234567890", salt: "shaker"}
  let(:encrypt3){AESKeeper::AESKeeperPure.new key: uuid, salt: "Example.com"}

  it "can be reproducible and optional PBKDF2" do
    enc = AESKeeper::AESKeeperPure.new key: "asdfghjklqwertyuiopzxcvbnm1234567890", salt: "shaker", armor: false
    enc.instance_exec {@iv="F5DC1E5A25F87C2201FE9B8D682D22CE"}
    a = enc.encrypt("asdf@moo.com").to_s

    enc = AESKeeper::AESKeeperPure.new key: "asdfghjklqwertyuiopzxcvbnm1234567890", salt: "shaker"
    enc.instance_exec {@iv="F5DC1E5A25F87C2201FE9B8D682D22CE"}
    b = enc.encrypt("asdf@moo.com").to_s

    enc = AESKeeper::AESKeeperPure.new key: "asdfghjklqwertyuiopzxcvbnm1234567890", salt: "shaker", armor: false
    enc.instance_exec {@iv="F5DC1E5A25F87C2201FE9B8D682D22CE"}
    c = enc.encrypt("asdf@moo.com").to_s

    _(a).must_equal c
    _(a).wont_equal b
    _(b).wont_equal c
  end

  it "produces a hash of size 2" do
    hsh = encrypt1.encrypt("moo")
    _(hsh).must_be_kind_of Hash
    _(hsh.size).must_be_same_as 2
    _(hsh).must_include :iv
    _(hsh).must_include :encrypted
  end

  it "pure aes results with injected iv will be consistent" do
    encrypt2.instance_exec {@iv = "\xF6s\x93<\xCB\x8DX\x88\x84\xB9J\x04\x93l^\x8F"}
    a = encrypt2.encrypt("asdf@moo.com").to_s
    b = encrypt2.encrypt("asdf@moo.com").to_s
    _(a).must_equal b 
  end

  it "can be as a string as well" do
    str = encrypt2.encrypt("moo").to_s
    _(str).must_be_kind_of String
    _(str.count(":")).must_be_same_as 1
  end

  it "encrypts and decrypts #1" do
    a = encrypt1.encrypt("moo")
    _(encrypt1.decrypt(a)).must_equal "moo"
  end

  it "encrypts and decrypts #2" do
    b = encrypt2.encrypt("moo")
    _(encrypt2.decrypt(b)).must_equal "moo"
  end

  it "encrypts and decrypts #3" do
    c = encrypt1.encrypt("moo").to_s
    _(encrypt1.decrypt(c)).must_equal "moo"
  end

  it "encrypts and decrypts #4" do
    d = encrypt2.encrypt("moo").to_s
    _(encrypt2.decrypt(d)).must_equal "moo"
  end

  it "encrypts and decrypts #5" do
    e = encrypt3.encrypt(uuid).to_s
    _(encrypt3.decrypt(e)).must_equal uuid    
  end
end


# ~> LoadError
# ~> cannot load such file -- minitest_helper
# ~>
# ~> /home/danielpclark/.rvm/rubies/ruby-2.2.3/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /home/danielpclark/.rvm/rubies/ruby-2.2.3/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /tmp/seeing_is_believing_temp_dir20160202-24131-1bft3zn/program.rb:1:in `<main>'

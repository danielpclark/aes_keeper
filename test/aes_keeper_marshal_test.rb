require 'minitest_helper'

describe AESKeeper::AesKeeperMarshal do
  let(:uuid)    { SecureRandom.uuid }
  let(:encrypt1){AesKeeper.new key: "asdfghjklqwertyuiopzxcvbnm1234567890"}
  let(:encrypt2){AesKeeper.new key: "asdfghjklqwertyuiopzxcvbnm1234567890", salt: "shaker"}
  let(:encrypt3){AesKeeper.new key: uuid, salt: "Example.com"}

  it "shows version for old implementation" do
    _(AesKeeper::VERSION.class).must_be_same_as String
  end

  it "produces a hash of size 2" do
    hsh = encrypt1.encrypt("moo")
    _(hsh).must_be_kind_of Hash
    _(hsh.size).must_be_same_as 2
    _(hsh).must_include :iv
    _(hsh).must_include :encrypted
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


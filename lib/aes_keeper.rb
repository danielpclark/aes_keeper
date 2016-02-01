require "aes_keeper/version"
require 'armor'
require 'base64'
require 'aes_keeper/aes_keeper_pure.rb'
require 'aes_keeper/aes_keeper_marshal.rb'

module AESKeeper
  ::AesKeeper = AesKeeperMarshal
end

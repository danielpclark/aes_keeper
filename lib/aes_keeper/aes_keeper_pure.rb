module AESKeeper
  class AesKeeperPure
    def initialize(options = {})
      raise ":key required!" unless options.has_key? :key
      raise ":key needs to be at-least 32 characters!" unless options[:key].length >= 32
      @key = key(options)
      @cipher = OpenSSL::Cipher::AES256.new(:CBC)
    end

    def encrypt(content, options = {})
      if (content != nil) and (content != "")
        @cipher.encrypt
        @cipher.key = key(options) || @key
        @iv ||= @cipher.random_iv
        @cipher.iv = @iv
        encrypted = @cipher.update content
        encrypted << @cipher.final
        {
          encrypted: Base64.encode64(encrypted).encode('utf-8'), iv: Base64.encode64(@iv).encode('utf-8')
        }.tap { |i|
          i.define_singleton_method(:to_s) { [self[:encrypted], self[:iv]].join(":") }
          i.define_singleton_method(:to_string) { [self[:encrypted], self[:iv]].join(":") }
        }
      else
        { encrypted: '', iv: ''}.tap {|i|
          i.define_singleton_method(:to_s){''}
          i.define_singleton_method(:blank?){true}
          i.define_singleton_method(:empty?){true}
          i.define_singleton_method(:presence){''}
          i.define_singleton_method(:present?){false}
        }
      end
    end

    def decrypt(options = {})
      if options.is_a? String
        text = options.dup
        options = {}
        if text.scan(/:/).one?
          options[:encrypted], options[:iv] = text.split(':')
        else
          raise 'Invalid String input!'
        end
      end
      raise ':encrypted required!' unless options.has_key?(:encrypted)
      raise ':iv required!' unless options.has_key?(:iv)
      raise ':encrypted invalid type!' unless options[:encrypted].is_a? String
      raise ':iv invalid type!' unless options[:iv].is_a? String
      return '' if options[:encrypted].strip.empty? and options[:iv].strip.empty?
      @cipher.decrypt
      @cipher.key =  key(options) || @key
      @cipher.iv = Base64.decode64(options[:iv].encode('ascii-8bit'))
      decrypted = @cipher.update Base64.decode64(options[:encrypted].encode('ascii-8bit'))
      begin
        decrypted << @cipher.final
        decrypted
      rescue
        raise 'Decryption failed.'
      end
    end

    def key(options = {})
      return nil unless options.has_key? :key
      options.has_key?(:salt) ? Armor.digest(options[:key], options[:salt]) : options[:key]
    end
  end
end

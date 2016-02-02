module AESKeeper
  class AESKeeperPure < AESKeeperCommon
    def encrypt(content, options = {})
      if (content != nil) and (content != "")
        @cipher.encrypt
        @cipher.key = key(options) || @key
        @iv ||= @cipher.random_iv
        @cipher.iv = @iv
        encrypted = @cipher.update content
        encrypted << @cipher.final
        stringable({
          encrypted: Base64.encode64(encrypted).encode('utf-8'), iv: Base64.encode64(@iv).encode('utf-8')
        })
       else
        nothing({ encrypted: '', iv: ''})
      end
    end

    def decrypt(options = {})
      decrypt_validations binding
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
  end
end

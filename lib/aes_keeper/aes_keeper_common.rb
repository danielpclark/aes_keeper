module AESKeeper
  class AESKeeperCommon
    VERSION = VERSION
    def initialize(options = {})
      raise ":key required!" unless options.has_key? :key
      raise ":key needs to be at-least 32 characters!" unless options[:key].length >= 32
      @key = key(options)
      @cipher = OpenSSL::Cipher::AES256.new(:CBC)
    end

    private
    def key(options = {})
      return nil unless options.has_key? :key
      if options.has_key?(:salt) && options.fetch(:armor) {true}
        Armor.digest(options[:key], options[:salt])
      else
        options[:key]
      end
    end

    def decrypt_validations bndng
      options = bndng.local_variable_get :options
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
      bndng.local_variable_set :options, options
    end

    def stringable obj
      obj.tap { |i|
        i.define_singleton_method(:to_s) { [self[:encrypted], self[:iv]].join(":") }
        i.define_singleton_method(:to_string) { [self[:encrypted], self[:iv]].join(":") }
      }
    end

    def nothing obj
      obj.tap {|i|
        i.define_singleton_method(:to_s){''}
        i.define_singleton_method(:blank?){true}
        i.define_singleton_method(:empty?){true}
        i.define_singleton_method(:presence){''}
        i.define_singleton_method(:present?){false}
      }
    end
  end
end

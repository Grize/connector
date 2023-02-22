module Support
  class JwtTestMixin
    def encode(payload, file_name)
      JWT.encode(payload, private_key(file_name), 'RS256')
    end

    private

    def private_key(file_name)
      OpenSSL::PKey::RSA.new(File.read("./spec/test_certificates/#{file_name}.pem"))
    end

    def algorithm
      { algorithm: 'RS256' }
    end

    def app_config
      YAML.load_file("#{ENV['PWD']}/config/connector.yml", aliases: true)[ENV['RAILS_ENV']]
    end
  end
end

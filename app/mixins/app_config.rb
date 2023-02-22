module AppConfig
  def public_key
    OpenSSL::PKey::RSA.new(File.read(config['public_certificate_path']))
  end

  def private_key
    OpenSSL::PKey::RSA.new(File.read(config['private_certificate_path']))
  end

  def app_id
    config['app_id']
  end

  def app_secret
    config['app_secret']
  end

  private

  def config
    YAML.load_file("#{ENV['PWD']}/config/connector.yml", aliases: true)[ENV['RAILS_ENV']]
  end
end

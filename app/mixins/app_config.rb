module AppConfig
  def self.public_key
    OpenSSL::PKey::RSA.new(File.read(config['public_certificate_path']))
  end

  def self.private_key
    OpenSSL::PKey::RSA.new(Rails.application.credentials.config[:app_private_key])
  end

  def self.app_id
    Rails.application.credentials.config[:salt_edge][:app_id]
  end

  def self.app_secret
    Rails.application.credentials.config[:salt_edge][:app_secret]
  end

  private

  def config
    YAML.load_file("#{ENV['PWD']}/config/connector.yml", aliases: true)[ENV['RAILS_ENV']]
  end
end

module SaltEdge
  def salt_edge_public_key
    OpenSSL::PKey::RSA.new(File.read(salt_edge_config['certificate_path']))
  end

  def salt_edge_path
    salt_edge_config['host']
  end

  private

  def salt_edge_config
    YAML.load_file("#{ENV['PWD']}/config/salt_edge.yml", aliases: true)[ENV['RAILS_ENV']]
  end
end

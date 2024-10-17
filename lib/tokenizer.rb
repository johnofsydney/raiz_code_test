class Tokenizer
  KEY = Digest::MD5.hexdigest('secret_key') # in production this would be stored in a secrets manager rather than in code

  def self.encrypt(user_id)
    encryptor.encrypt_and_sign(user_id, expires_in: 1.day)
  end

  def self.decrypt(token)
    encryptor.decrypt_and_verify(token)
  end

  private

  def self.encryptor
    @encryptor ||= ActiveSupport::MessageEncryptor.new(KEY)
  end
end
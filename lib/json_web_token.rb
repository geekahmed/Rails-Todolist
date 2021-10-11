class JsonWebToken
    SECRET_KEY = "This is a development secret key" # put your secret key here
  
    def self.encode(payload, exp = 30.minutes.from_now) # change expiry of token by entering exp time here
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end
  end
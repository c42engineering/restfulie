#Registrar component for unmarshallers on the server side. Unmarshallers are responsible for
#unmarshalling request-received content into ruby objects.
class Restfulie::Server::HTTP::Unmarshal

  @@unmarshals = {}

  ## 
  # :singleton-method:
  # Use it to register marshaller/unmarshallers on the server side.
  #
  # * <tt>media type</tt>
  # * <tt>marshaller</tt>
  #
  #==Example:
  #
  #   module FakeMarshaller
  #    def self.unmarshal(content)
  #     ...
  #    end
  #   end
  #   
  #   Restfulie::Server::HTTP::Unmarshall.register('application/atom+xml',FakeMarshal)
  #
  def self.register(content_type,marshal)
    @@unmarshals[content_type] = marshal
  end

  # Unmarshals response's body according to content-type header.
  # If no marshal registered will return Raw instance
  def unmarshal(request)
    content_type = request.headers['CONTENT_TYPE']
    unmarshaller = @@unmarshals[content_type]
    raise Restfulie::Server::HTTP::UnsupportedMediaTypeError unless unmarshaller
    unmarshaller.unmarshal(request.body.read)
  end

end

class Restfulie::Server::HTTP::UnsupportedMediaTypeError < Exception
end

class Restfulie::Server::HTTP::BadRequest < Exception
end

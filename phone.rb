class Phone
  attr_reader :id
  attr_accessor :phone, :type

  def initialize (id, phone, type)
    @id = id
    @phone = phone
    @type = type
  end
end
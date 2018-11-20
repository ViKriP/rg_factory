require_relative 'factory'

Customer = Factory.new(:name, :address, :zip)
# => Customer

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
# => #<struct Customer name="Joe Smith", address="123 Maple, Anytown NC", zip=12345>

puts joe
=begin
puts joe.name    # => "Joe Smith"

puts joe['name'] # => "Joe Smith"
puts joe[:name]  # => "Joe Smith"
puts joe[0]      # => "Joe Smith"

Customer = Struct.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

Customer.new('Dave', '123 Main').greeting # => "Hello Dave!"
=end

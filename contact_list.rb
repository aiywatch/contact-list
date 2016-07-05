#!/usr/bin/env ruby

require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  PHONE_DICT = { "home" => 'h', "work" => "w", "mobile" => "m" }
  attr_accessor :contact_list
  
  def initialize
    case ARGV[0]
    when "new"
      @contact_list = []
    when "list"
      @contact_list = Contact.all
    when "show"
      @contact_list = Contact.find(ARGV[1])
    when "search"
      @contact_list = Contact.search(ARGV[1])
    else
      @contact_list = []
    end
      
  end
  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

  def start
    case ARGV[0]
    when "new"
      puts "Please enter the name"
      name = $stdin.gets.strip
      puts "Please enter the email address"
      email = $stdin.gets.strip
      raise ArgumentError, "Name and Email must have value" if name.empty? or email.empty?
      phones = []
      while true
        puts "Optional phone number ('yes' to continue)"
        opt = $stdin.gets.strip
        break if opt != 'yes'
        puts "home/work/mobile"
        opt2 = $stdin.gets.strip
        raise ArgumentError, "invalid input" if opt2 != 'home' and opt2 != 'work' and opt2 != 'mobile'
        puts "enter phone number"
        phone = $stdin.gets.strip
        phones << opt2 + ':' + phone
      end
      p phones
      Contact.create(name, email, phones)
      
    when "list"
      all_contact = Contact.all
      display_contact

    when "show"
      puts "show"

      puts "#{@contact_list.name} and #{contact_list.email}"
      

    when "search"
      raise ArgumentError, "Must have exactly 2 argument" if ARGV.size != 2
      display_contact
      # @contact_list.each_with_index { |contact, i| puts "#{contact.name} (#{contact.email})" }
      # puts "---\n#{@contact_list.size} record total"
    else
      puts "no command"

    end
  end

  def display_contact
    i = 0

    while !@contact_list[i].nil?

      5.times do 
        contact = @contact_list[i]
        i += 1
        puts "#{i}: #{contact.name} (#{contact.email})"
        break if @contact_list[i].nil?  
      end
      break if @contact_list[i].nil?  
      puts "enter to continue ..."
      $stdin.gets
    end

    puts "---"
    puts "#{i} records total"
  end

  def serialize(phones)
    phones.join("::")
    # PHONE_DICT.each do |key, value|
    #   p key
    #   p value
    #   str.gsub!(key, value)
    # end
    # str
  end

  def deserialize(phones)
    # PHONE_DICT.each do |key, value|
    #   p key
    #   p value
    #   phones.gsub!(value, key)
    # end
    phones.split('::')
  end
end


# ContactList.new.start()




# x = "a:123:b:456"
# #result = ['a'=>123, 'b'=>456]

# result = 
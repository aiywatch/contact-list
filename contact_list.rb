#!/usr/bin/env ruby

require_relative 'contact'
require_relative 'phone'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  PHONE_DICT = { "home" => 'h', "work" => "w", "mobile" => "m" }
  attr_accessor :contact_list
  
  def initialize
    @contact_list = []
      
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
      # while true
      #   puts "Optional phone number ('yes' to continue)"
      #   opt = $stdin.gets.strip
      #   break if opt != 'yes'
      #   puts "home/work/mobile"
      #   opt2 = $stdin.gets.strip
      #   raise ArgumentError, "invalid input" if opt2 != 'home' and opt2 != 'work' and opt2 != 'mobile'
      #   puts "enter phone number"
      #   phone = $stdin.gets.strip
      #   phones << opt2 + ':' + phone
      # end
      # p phones
      @contact_list << Contact.create(name: name, email: email)
      display_contact
    when "list"
      @contact_list = Contact.all
      display_contact

    when "show"
      @contact_list << Contact.find(ARGV[1].to_i)
      display_contact

    when "search"
      raise ArgumentError, "Must have exactly 2 argument" if ARGV.size != 2
      @contact_list = Contact.where('name ~* ? OR email ~* ?', ARGV[1], ARGV[1])
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
        puts "#{contact.id}: #{contact.name} (#{contact.email})"
        break if @contact_list[i].nil?  
      end
      break if @contact_list[i].nil?  
      puts "enter to continue ..."
      $stdin.gets
    end

    puts "---"
    puts "#{i} records total"
  end

end

# Contact.create('test3', 'test3@test.com')

# contact = Contact.find(2)
# contact.add_phone('6045567493', 'mobile')
# p Contact.all
# contact.name = 'test44'
# contact.email = 'test44@mail.com'
# contact.save
# contact.destroy
# p Contact.all

# p Contact.has_email?('test22@test.com')

ContactList.new.start()

# p Contact.all



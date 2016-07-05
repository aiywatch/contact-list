require 'pg'
require 'csv'
require 'pry'
require_relative 'phone'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact
  # @@conn = nil
  attr_reader :id
  attr_accessor :name, :email, :phones
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)
    # TODO: Assign parameter values to instance variables.
    @id = id
    @name = name
    @email = email
    @phones = []
  end

  def save
    conn = Contact.connection
    if new_contact?
      # puts 'Inserting new contact...'
      @id = conn.exec_params('INSERT INTO contacts (name, email) 
        VALUES ($1, $2) RETURNING id;', [name, email])
      # puts 'Complete insert...'
      # self
    else
      # puts 'Updating contact...'
      conn.exec_params('UPDATE contacts 
        SET name = $1, email = $2 WHERE id = $3::int;', 
        [name, email, id])
      # self
    end
    self
  end

  def destroy
    conn = Contact.connection
    # puts 'Deleting contact...'
    conn.exec_params('DELETE FROM contacts WHERE id = $1::int;', [id])
    puts 'destroy!'
  end

  def add_phone(number, type)
    conn = Contact.connection
    puts 'adding phone...'
    phone_id = conn.exec_params('INSERT INTO phones (contact_id, number, type)
      VALUES ($1, $2, $3) RETURNING id;', [id, number, type])
    phones << Phone.new(phone_id, number, type)
  end

  private

  def new_contact?
    id.nil?
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    def connection
      # puts 'Connecting to the database...'
      conn = PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
      )
      conn
    end

    def has_email?(email)
      contacts = []
      conn = Contact.connection
      # puts 'finding contact with the email..'
      conn.exec_params('SELECT * FROM contacts 
        WHERE email = $1', [email]) do |results|
        results.each do |contact|
          contacts << contact
        end
      end
      !contacts.empty?
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      conn = Contact.connection
      # puts 'Finding contacts...'
      conn.exec('SELECT * FROM contacts;') do |results|
        results.each do |contact|
          # puts contact.inspect
          contact_new = Contact.new(contact['id'], contact['name'], contact['email'])
          contact_new.phones.concat(find_phones(contact['id']))
          contacts << contact_new
        end
      end
      # puts 'Closing the connection...'
      contacts
    end

    def find_phones(id)
      contact_phones = []
      conn = Contact.connection
      conn.exec_params('SELECT * FROM phones WHERE contact_id = $1;', [id]) do |results|
        results.each do |phone|
          # puts contact.inspect
          contact_phones << Phone.new(phone['id'], phone['number'], phone['type'])
        end
      end
      contact_phones
    end
    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phones = [])
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(nil, name, email)
      contact.save

      # all = CSV.read('list.csv').flatten
      # if all.include?(email)
      #   puts "The email already exist"
      # else
      #   CSV.open('list.csv', 'a') do |list|
      #     list << [name, email, phones]
      #   end
      #   p "#{name} with #{email} and #{phones} has been added}"
      # end
    end
      
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      conn = Contact.connection
      conn.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id]) do |results|
        results.each do |contact|
          return Contact.new(contact['id'], contact['name'], contact['email'])
        end
      end
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      ans = []
      CSV.foreach('list.csv') do |row|
        row.each do |col|
          ans << Contact.new(row[0], row[1]) if col.include?(term)
          break
        end
      end
      ans
    end

  end

end

# phones
# id 
# contact_id
# number
# type

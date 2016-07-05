require 'csv'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email

  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      all_contacts = []
      CSV.foreach('list.csv') do |row|
        all_contacts << Contact.new(row[0],row[1])
      end
      all_contacts
      # all_contacts = []
      # # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      # CSV.foreach('list.csv') do |row|

      #   all_contacts << Contact.new(row[0],row[1])
      # end
      

      # all_contacts
      # CSV.read('list.csv')
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phones = [])
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      all = CSV.read('list.csv').flatten
      if all.include?(email)
        puts "The email already exist"
      else
        CSV.open('list.csv', 'a') do |list|
          list << [name, email, phones]
        end
        p "#{name} with #{email} and #{phones} has been added}"
      end
    end
      
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      all[id.to_i]
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

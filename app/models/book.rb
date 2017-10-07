class Book
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations
  include Mongoid::Search
  #include Sunspot::Mongoid2
  
  field :name,                   type: String
  field :short_description,      type: String
  field :long_description,       type: String
  field :date_of_publication,    type: Date
  field :genre,                  type: Array

  validates :name, :short_description, :long_description, :date_of_publication, presence: true

  has_and_belongs_to_many :authors
  has_many :reviews

  search_in :name, :short_description, :long_description, :date_of_publication, :genre
  
  index({ genre: 1 })

  def as_json
    {
      id: _id.to_s,
      name: name,
      short_description: short_description,
      long_description: long_description,
      date_of_publication: date_of_publication,
      genre: genre,
      authors: authors.as_json,
      reviews: reviews.as_json
    }
  end

  def self.search(query)
    books = []
    books = books + Book.full_text_search(query).to_a
    books = books + Author.full_text_search(query).map(&:books) 
    books = books + Review.full_text_search(query).map(&:book)

    books.uniq.flatten.compact
  end
end


class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations
  include Mongoid::Search

  field :title,                  type: String
  field :description,            type: String
  field :rating,                 type: Integer

  validates :title, :description, presence: true

  belongs_to :book, index: true
  belongs_to :user, index: true

  search_in :title, :description, :rating

  index({ title: 1 })

  def as_json
    {
      id: _id.to_s,
      name: title,
      description: description,
      rating: rating,
      user: user.as_json
    }
  end
end
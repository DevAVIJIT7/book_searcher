class Author < User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations
  include Mongoid::Search

  field :bio,              type: String
  field :profile_pic,      type: BSON::Binary
  field :academics,        type: String
  field :awards,           type: String

  validates :bio, presence: true, length: { minimum: 50, maximum: 100 }

  has_and_belongs_to_many :books

  search_in :name, :bio, :academics, :awards

  index({ name: 1 })

  def as_json
    {
      id: _id.to_s,
      name: name,
      bio: bio,
      profile_pic: profile_pic,
      academics: academics,
      awards: awards
    }
  end
end

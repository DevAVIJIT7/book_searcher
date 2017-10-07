class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  EXPIRE_TIME = 3600
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :access_token,       type: String
  field :name,               type: String
  field :access_token_expire_time, type: DateTime

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  validates :name, presence: true

  has_many :reviews

  after_create :generate_access_token

  def generate_access_token
    update(access_token: Devise.friendly_token,
           access_token_expire_time:(Time.now+(EXPIRE_TIME*60)))
    return self.access_token
  end

  def self.user_login(email, password)
    user = User.where(email: email).first
    if user && user.valid_password?(password)
      access_token = user.generate_access_token
      data = { user_id: user._id.to_s, 
               name: user.name , 
               access_token: access_token, 
               access_token_expire_time: user.access_token_expire_time
      }
      
      message = I18n.t 'sessions.successful.signed_in'
      {status: 200, message: message, data: data}
    else
      message = I18n.t 'sessions.failure.invalid'
      {status: 400, message: message, data: nil}
    end
  end

  def as_json
    {
      id: _id.to_s,
      name: name
    }
  end
end

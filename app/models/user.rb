class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  searchkick
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

  has_secure_password
  embeds_many :todo_units, class_name: "TodoUnit", inverse_of: :user
 
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_presence_of :name, :password_digest

  def search_data
    {
      name: name,
      email: email,
      todos: todo_units.map do |to|
        {
          title: to.title,
          desc: to.desc
        }
      end
    }
  end
end

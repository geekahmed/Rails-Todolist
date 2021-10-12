class TodoUnit
  include Mongoid::Document
  
  field :title, type: String
  field :image_link, type: String
  field :desc, type: String

  searchkick

  mount_base64_uploader :image_link, ImageUploader
  validates :title, presence: true

  embedded_in :user, class_name: "User", inverse_of: :todo_units
  
  def as_json(*args)
    res = super
    res["id"] = res.delete("_id").to_s
    res
  end
  def search_data
    as_json only: [:title, :desc]
  end
end

class CsvExportJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    return if user_id.blank?
    todolist = User.find(user_id).todo_units
    puts todolist 
    attributes = %w{_id title desc}
    CSV.open("#{Rails.root}/public/#{user_id}-todos-#{Date.today}.csv", "wb") do |csv|
      csv << attributes
      todolist.each do |todo|
        csv << todo.attributes.values_at(*attributes)
      end
    end

    ActionCable.server.broadcast(
      "todo_units_channel",
      {csv_url: "http://localhost:5000/#{user_id}-todos-#{Date.today}.csv"}
    )
  end
end

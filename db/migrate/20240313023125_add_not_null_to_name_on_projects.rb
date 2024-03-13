class AddNotNullToNameOnProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_null :projects, :name, false
  end
end

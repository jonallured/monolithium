class AddDefaultValues < ActiveRecord::Migration[5.1]
  def change
    column_names = %i[adjust_minutes in_minutes out_minutes pto_minutes]

    column_names.each do |column_name|
      change_column_default :work_days, column_name, from: nil, to: 0
      change_column_null :work_days, column_name, false
    end
  end
end

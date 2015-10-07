class AddDirectorColumn < ActiveRecord::Migration
  def up
  	add_column :movies, :director, :string
  end

  def down
  	remove_column :Director
  end
end

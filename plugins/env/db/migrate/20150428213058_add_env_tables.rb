class AddEnvTables < ActiveRecord::Migration
  def change
    add_column :stages, :env, :text
  end
end

# db/migrate/20210407142948_create_goals.rb
class AddEnumsToGoals < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE goal_aim AS ENUM ('aspiration', 'hope', 'meaning');
      CREATE TYPE goal_length AS ENUM('short_term', 'long_term');
    SQL

    add_column :goals, :aim, :goal_aim
    add_column :goals, :length, :goal_length

    add_index :goals, :aim
    add_index :goals, :length
  end

  def down
    remove_index :goals, :aim
    remove_index :goals, :length

    remove_column :goals, :aim
    remove_column :goals, :length

    execute <<-SQL
      DROP TYPE goal_aim;
      DROP TYPE goal_length;
    SQL
  end
end

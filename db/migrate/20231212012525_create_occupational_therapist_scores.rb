class CreateOccupationalTherapistScores < ActiveRecord::Migration[6.1]
  def change
    create_table :occupational_therapist_scores do |t|
      t.string :learning_and_applying_knowledge
      t.string :functional_walking_and_mobility
      t.string :upper_limb_use
      t.string :carrying_out_daily_life_tasks_and_routines
      t.string :transfers
      t.string :using_transport
      t.string :self_care
      t.string :domestic_life_home
      t.string :domestic_life_managing_resources
      t.string :interpersonal_interactions_and_relationships
      t.string :work_employment_and_education
      t.string :community_life_recreation_leisure_and_play
      t.string :participation_restriction
      t.string :distress_or_wellbeing
      t.references :user, foreign_key: true
      t.references :team_member, foreign_key: true

      t.timestamps
    end
  end
end

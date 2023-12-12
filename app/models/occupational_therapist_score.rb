# app/models/occupational_therapist_score.rb
class OccupationalTherapistScore < ApplicationRecord
  belongs_to :user
  belongs_to :team_member

  OPTIONS = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    'N/A'
  ].freeze

  validates :learning_and_applying_knowledge, inclusion: { in: OPTIONS }
  validates :functional_walking_and_mobility, inclusion: { in: OPTIONS }
  validates :upper_limb_use, inclusion: { in: OPTIONS }
  validates :carrying_out_daily_life_tasks_and_routines, inclusion: { in: OPTIONS }
  validates :transfers, inclusion: { in: OPTIONS }
  validates :using_transport, inclusion: { in: OPTIONS }
  validates :self_care, inclusion: { in: OPTIONS }
  validates :domestic_life_home, inclusion: { in: OPTIONS }
  validates :domestic_life_managing_resources, inclusion: { in: OPTIONS }
  validates :interpersonal_interactions_and_relationships, inclusion: { in: OPTIONS }
  validates :work_employment_and_education, inclusion: { in: OPTIONS }
  validates :community_life_recreation_leisure_and_play, inclusion: { in: OPTIONS }
  validates :participation_restriction, inclusion: { in: OPTIONS }
  validates :distress_or_wellbeing, inclusion: { in: OPTIONS }
end

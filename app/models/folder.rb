# app/models/folder.rb
class Folder < ApplicationRecord
  has_many :child_folders, class_name: 'Folder', foreign_key: 'parent_folder_id', dependent: :destroy
  has_many :uploads, foreign_key: 'parent_folder_id'
  belongs_to :parent_folder, class_name: 'Folder', optional: true
  belongs_to :user, optional: true
  belongs_to :team_member

  validates_presence_of :name
  validates_format_of :name, with: Rails.application.config.regex_name,
                             message: Rails.application.config.name_error
end

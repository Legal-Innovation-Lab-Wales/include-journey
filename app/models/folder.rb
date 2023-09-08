# app/models/folder.rb
class Folder < ApplicationRecord
  has_many :child_folders, class_name: 'Folder', foreign_key: 'parent_folder_id', dependent: :destroy
  has_many :uploads, foreign_key: 'parent_folder_id'
  belongs_to :parent_folder, class_name: 'Folder', optional: true
  belongs_to :team_member
end

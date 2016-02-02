class Tag < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :tag_id
  has_many :contents, through: :content_tags

  scope :recommend, -> { where( :display => 1 ).select( :id, :name ).order( :count => :desc ) }
end

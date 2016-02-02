class Content < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :content_id
  has_many :tags, through: :content_tags

  scope :liked, -> { select( :id, :title ).order( count: :desc ).limit( 6 ) }
  scope :latest, -> { select( :id, :title ).order( created_at: :desc ).limit( 6 ) }
end

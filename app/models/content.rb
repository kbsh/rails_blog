class Content < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :content_id
end

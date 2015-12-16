class Tag < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :tag_id
end

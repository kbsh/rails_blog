class ContentTag < ActiveRecord::Base
  belongs_to :tag, foreign_key: :tag_id
  belongs_to :content, foreign_key: :content_id
end

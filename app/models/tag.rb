class Tag < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :tag_id
  has_many :contents, through: :content_tags

  include RedisModule

  # お勧めタグを返却する
  scope :recommend, -> {
    # ユーザー共通のKVSキー
    kvs_key = "recommend_tags"
    # KVS有効期限 24h
    kvs_ttl = 60 * 60 * 24

    # kvsからデータを取得する
    recommends = redis_get( kvs_key )

    # 取得できていなければDBから取得し、セットする
    if( recommends.empty? )
      recommends = where( :display => 1 ).select( :id, :name ).order( :count => :desc ).to_json
      redis_set( kvs_key, recommends, kvs_ttl)
    end

    JSON.parse( recommends )
  }
end

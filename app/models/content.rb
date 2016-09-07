class Content < ActiveRecord::Base
  has_many :content_tags, dependent: :destroy, foreign_key: :content_id
  has_many :tags, through: :content_tags

  include RedisModule

  # お勧め記事を取得
  scope :liked, -> {
    # ユーザー共通のKVSキー
    kvs_key = "liked_contents"
    # KVS有効期限 24h
    kvs_ttl = 60 * 60 * 24

    # kvsからデータを取得する
    liked = redis_get( kvs_key )

    # 取得できていなければDBから取得し、セットする
    if( liked.empty? )
      liked = select( :id, :title ).order( count: :desc ).limit( 6 ).to_json
      redis_set( kvs_key, liked, kvs_ttl)
    end

    JSON.parse( liked )
  }

  # 最新記事を取得
  scope :latest, -> {
    # ユーザー共通のKVSキー
    kvs_key = "latest_contents"
    # KVS有効期限 24h
    kvs_ttl = 60 * 60 * 24

    # kvsからデータを取得する
    latest = redis_get( kvs_key )

    # 取得できていなければDBから取得し、セットする
    if( latest.empty? )
      latest = select( :id, :title ).order( created_at: :desc ).limit( 6 ).to_json
      redis_set( kvs_key, latest, kvs_ttl)
    end

    JSON.parse( latest )
  }
end

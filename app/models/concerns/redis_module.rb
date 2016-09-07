require 'active_support/concern'

##
# Redisの操作を行う
#
module RedisModule
  extend ActiveSupport::Concern

  included do
    #
    # 値を取得する
    #
    # @param  string key キー
    # @return string
    #
    def self.redis_get( key )
      REDIS.get( key )
    end

    #
    # 値をセットする
    #
    # @param  string key   キー
    # @param  mixed  value 値
    # @param  int    ttl   有効時間
    # @return string
    #
    def self.redis_set( key, value, ttl )
      REDIS.multi do
        REDIS.set( key, value )
        if ttl.present?
          REDIS.expire( key, ttl )
        end
      end
    end
  end
end

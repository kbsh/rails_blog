require 'active_support/concern'

module ContentSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # index名
    index_name "index_content"

    # config
    settings index: {
      number_of_shards:   1,
      number_of_replicas: 0,
      analysis: {
        filter: {
          pos_filter: {
            type: 'kuromoji_part_of_speech',
            stoptags: ['助詞-格助詞-一般', '助詞-終助詞'],
          },
          greek_lowercase_filter: {
            type:     'lowercase',
            language: 'greek',
          },
        },
        tokenizer: {
          kuromoji: {
            type: 'kuromoji_tokenizer',
          },
          ngram_tokenizer: {
            type: 'nGram',
            min_gram: '2',
            max_gram: '3',
            token_chars: ['letter', 'digit']
          }
        },
        analyzer: {
          kuromoji_analyzer: {
            type:      'custom',
            tokenizer: "kuromoji_tokenizer",
            filter:    ['kuromoji_baseform', 'greek_lowercase_filter', 'cjk_width'],
          },
          ngram_analyzer: {
            tokenizer: "ngram_tokenizer"
          }
        }
      }
    } do
      mapping _source: { enabled: true }, 
_all: { enabled: true, analyzer: "kuromoji_analyzer" } do
        indexes :id, type: 'integer', index: 'not_analyzed'
        indexes :filename, type: 'string', index: 'not_analyzed'
        indexes :title, type: 'string', analyzer: 'kuromoji_analyzer'
        indexes :count, type: 'integer', index: 'not_analyzed'
      end
    end
  end

  module ClassMethods
    def create_index!( options = {} )
      client = __elasticsearch__.client
      client.indices.delete index: "index_content" rescue nil if options[:force]
      client.indices.create index: "index_content",
      body: {
        settings: settings.to_hash,
        mappings: mappings.to_hash
      }
    end

    # キーワードから検索し、レコードを返却
    # @param [array] keywords 検索ワード
    # @param [integer] offset 検索除外件数（取得開始位置）
    # @param [integer] limit 取得件数
    # @param [integer] is_count 件数取得か
    # @return [ActiveRecord/integer] Contentクラス / 取得件数
    def search_ids( keywords, offset, limit, is_count = false )
      must_keywords = ""
      mustnot_keywords = ""

      # スペースごとに検索文字を切り出す
      keywords.split(/\s| |　/).each do | keyword |
        # 先頭文字が「-」の場合は除外条件
        if ( keyword.slice( 0, 1 ) == '-' )
          unless mustnot_keywords.empty?
            mustnot_keywords << " OR"
          end
          keyword.slice!( 0 )
          mustnot_keywords << " #{keyword}"
        else
          unless must_keywords.empty?
            must_keywords << " AND"
          end
          must_keywords << " #{keyword}"
        end
      end

      # 件数のみ取得の場合、offset, limitを固定する
      if is_count
        offset = 0;
        limit = 100;
      end

      # elasticsearchから検索
      contents = Content.search(
        {
          query: {
            bool: {
              must: [
                query_string: {
                  default_field: "title",
                  query: must_keywords
                }
              ],
              must_not: [
                query_string: {
                  default_field: "title",
                  query: mustnot_keywords
                }
              ]
            }
          },
          from: offset,
          size: limit
        }
      )

      # 件数のみ取得の場合、返却
      if is_count
        return contents.count
      end

      # idをcsvでまとめ、RDBから検索
      ids = Array[]
      contents.each do | content |
        ids << content.id
      end
      Content.where( id: ids )
    end
  end
end

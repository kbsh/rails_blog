module PostHelper

  # タグを取得する
  # @param [activerecord] content Contentモデル
  # @return [string] タグボタン
  def post_tags( content )

    html = "<div class='tag_area'>"

    content.tags.each do | tag |
      html += link_to(
        tag.name,
        # TODO タグのパスを改める
        post_list_by_tag_path( i:tag.id ),
        :class => "btn btn-default btn-xs"
      )
    end

    html += "</div>"
    html += "<div class='clearfix'></div>"
    html.html_safe

  end

  # 記事本文の省略表示用文字列を取得する
  # @param [activerecord] content Contentモデル
  # @return [string] 本文の省略文字列
  def post_excerpt( content )

    # 記事取得
    article = render( :partial => content.filename )
    # htmlタグを削除
    article = strip_tags( article )
    # markdownタグを削除
    article = article.delete( "#*`" )
    # n文字に省略
    article = truncate( article, :length => 100 )

    html = ""
    html += "<small>"
    html += article
    html += "</small>"

    html.html_safe

  end

  # ページネーションを出力
  # @param [integer] page 現在ページ数
  # @param [integer] step 各ページ表示数
  # @param [integer] count 件数
  # @param [integer] tag_id タグID
  # @param [string] keywords キーワード
  # @return [string] DOM
  def pagination( page, step, count, tag_id, keywords )

    # 総ページ数
    page_count = ( count.to_f / step ).ceil

    # 1ページのみの場合は返却
    return if( page_count <= 1 )

    html = "<div class='text-center'>"
    html += "<ul class='pagination pagination-lg'>"

    # 先頭ページへのリンク
    if( tag_id.present? )
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&laquo;'.html_safe, post_list_by_tag_path( p:1, i:tag_id ) }</li>"
    elsif( keywords.present? )
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&laquo;'.html_safe, post_list_by_search_path( p:1, q:keywords ) }</li>"
    else
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&laquo;'.html_safe, root_path( p:1 ) }</li>"
    end

    # 1 ~ 最終ページへのリンク
    for i in 1..page_count do
      if( tag_id.present? )
        html += "<li class='#{ page == i ? 'active' : '' }'>#{ link_to i, post_list_by_tag_path( p:i, i:tag_id ) }</li>"
    elsif( keywords.present? )
        html += "<li class='#{ page == i ? 'active' : '' }'>#{ link_to i, post_list_by_search_path( p:i, q:keywords ) }</li>"
      else
        html += "<li class='#{ page == i ? 'active' : '' }'>#{ link_to i, root_path( p:i ) }</li>"
      end
    end

    # 最終ページへのリンク
    if( tag_id.present? )
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&raquo;'.html_safe, post_list_by_tag_path( p:1, i:tag_id ) }</li>"
    elsif( keywords.present? )
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&raquo;'.html_safe, post_list_by_search_path( p:1, q:keywords ) }</li>"
    else
      html += "<li class='#{ page == 1 ? 'disabled' : '' }'>#{ link_to '&raquo;'.html_safe, root_path( p:1 ) }</li>"
    end

    html += "</ul>"
    html += "</div>"

    html.html_safe
  end

end

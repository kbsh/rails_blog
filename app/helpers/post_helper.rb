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

end

module ApplicationHelper
  @@markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML,
    autolink: true,
    space_after_headers: true,
    no_intra_emphasis: true,
    fenced_code_blocks: true,
    tables: true,
    hard_wrap: true,
    xhtml: true,
    lax_html_blocks: true,
    strikethrough: true

  # マークダウン形式でview表示
  # @params [string] text markdown
  # @return [string] html
  #
  def markdown( text )
    @@markdown.render(text).html_safe
  end

  # 年月アイコンを表示
  # @params [datetime] datetime
  # @return [string] html
  #
  def date_icon( datetime )

    html = "<div class='date_area label-info'>"
    html += "<span class='year'>#{ datetime.to_s( :year )}</span>"
    html += "<span class='day'>#{ datetime.to_s( :date ) }</span>"
    html += "</div>"

    html.html_safe

  end
  
end

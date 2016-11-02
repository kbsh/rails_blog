class PostController < ApplicationController
  before_action :set_page, only: [:list, :list_by_tag]

  def list
    @count = Content.all.count
    @contents = Content.all
      .order( :created_at => :desc )
      .offset( ( @page - 1 ) * @step )
      .limit( @step )
  end

  def list_by_tag
    @tag_id = params['i'] ? params['i'].to_i : 1

    tag = Tag.find( @tag_id )

    @count = tag.contents.count
    @contents = tag.contents
      .order( :created_at => :desc )
      .offset( @step * @page - @step - 1 )
      .limit( @step )

    # 訪問数をインクリメント
    tag.count.succ
    tag.save

    render "list"
  end

  def search
    content_id = params['i'] ? params['i'].to_i : 1
    @content = Content.find( content_id )

    # 訪問数をインクリメント
    @content.count.succ
    @content.save
    @content.tags.each do | tag |
      tag.count.succ
      tag.save
    end
  end

  def set_page
    @page = params['p'] ? params['p'].to_i : 1
    @step = 10
  end

end

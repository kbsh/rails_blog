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
    tag_id = params['i'] ? params['i'].to_i : 1

    @count = Tag.find( tag_id ).contents.count
    @contents = Tag.find( tag_id ).contents
      .order( :created_at => :desc )
      .offset( @step * @page - @step - 1 )
      .limit( @step )

    render "list"
  end

  def search
    content_id = params['i'] ? params['i'].to_i : 1
    @content = Content.find( content_id )
  end

  def set_page
    @page = params['p'] ? params['p'].to_i : 1
    @step = 10
  end

end

class PostController < ApplicationController
  def list
    @contents = Content.all.order( :created_at => :desc )
  end

  def list_by_tag
    tag_id = params['i'] ? params['i'].to_i : 1
    @contents = Tag.find( tag_id ).contents.order( :created_at => :desc )
    render "list"
  end

  def search
    content_id = params['i'] ? params['i'].to_i : 1
    @content = Content.find( content_id )
  end
end

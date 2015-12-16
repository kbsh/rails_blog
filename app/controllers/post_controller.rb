class PostController < ApplicationController
  def list
    @contents = Content.all.order( :created_at => :desc )
  end

  def list_by_tag
    tag_id = params['i'] ? params['i'].to_i : 1

    # existsを使いたかったのでarelを用いる
    content = Content.arel_table
    content_tag = ContentTag.arel_table
 
    @contents = Content.where( # select from content where
      content_tag # from content_tag
        .project( Arel.star ) # select *
        .where( content_tag[ :content_id ].eq( content[ :id ] ) ) # where content_tag.content_id = content.id
        .where( content_tag[ :tag_id ].eq( tag_id ) ) # and content_tag.tag_id = #{ tag_id }
        .exists # exists
    ).order( :created_at => :desc )

    render "list"
  end

  def search
    content_id = params['i'] ? params['i'].to_i : 1
    @content = Content.find( content_id )
  end
end

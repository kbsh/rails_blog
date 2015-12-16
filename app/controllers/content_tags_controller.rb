class ContentTagsController < ApplicationController
  before_action :set_content_tag, only: [:show, :edit, :update, :destroy]

  # GET /content_tags
  # GET /content_tags.json
  def index
    @content_tags = ContentTag.all
  end

  # GET /content_tags/1
  # GET /content_tags/1.json
  def show
  end

  # GET /content_tags/new
  def new
    @content = Content.find( params[:ci] )
    @content_tag = ContentTag.new
  end

  # GET /content_tags/1/edit
  def edit
  end

  # POST /content_tags
  # POST /content_tags.json
  def create
    @content_tag = ContentTag.new(content_tag_params)
    if @content_tag.save
      return redirect_to contents_path
    end
  end

  # PATCH/PUT /content_tags/1
  # PATCH/PUT /content_tags/1.json
  def update
    if @content_tag.update(content_tag_params)
      return redirect_to contents_path
    end
  end

  # DELETE /content_tags/1
  # DELETE /content_tags/1.json
  def destroy
    @content_tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content_tag
      @content_tag = ContentTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_tag_params
      params.require(:content_tag).permit(:content_id, :tag_id)
    end
end

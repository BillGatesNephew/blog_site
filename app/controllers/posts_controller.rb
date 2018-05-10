class PostsController < ApplicationController
  before_action :set_sorting_method_names
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_author!, only: [:new, :edit, :create, :update]

  
  # GET /sort_posts/
  def sort_posts
    session[:sorting_method] = sort_param["method"]
    redirect_back fallback_location: :root
  end 


  # GET /tag/complexity_theory
  def tag_posts
    @tag = Tag.where('lower(name) = ?', params["tag_name"].downcase).first
    if @tag
      @posts = @tag.posts
      sort_posts_by_method(session[:sorting_method])
    else 
      redirect_to :root
    end 
  end 

  # GET /author/walker
  def author_posts
    @author = Author.where('lower(name) = ?', params["author_name"].downcase).first
    if @author 
      @posts = @author.posts
      sort_posts_by_method(session[:sorting_method])
    else 
      redirect_to :root
    end 
  end 

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    sort_posts_by_method(session[:sorting_method])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @initial_tags = Array.new
    Tag.all.each {|tag| @initial_tags << tag.name }
    @current_tags = Array.new
  end

  # GET /posts/1/edit
  def edit
    if @post.author == current_author 
      @initial_tags = Array.new
      Tag.all.each {|tag| @initial_tags << tag.name }
      @current_tags = Array.new
      Posttag.tags_for_post(@post).each {|tag| @current_tags << tag.name }
    else
      redirect_to :root 
    end 
  end

  # POST /posts
  # POST /posts.json
  def create
    tags = params["post_tags"].split(',')
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        Posttag.add_tags_to_post(@post, tags)
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    tags = params["post_tags"].split(',')
    respond_to do |format|
      if @post.update(post_params)
        Posttag.add_tags_to_post(@post, tags)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def sorting_methods
      return {
        'Title' => {
          'A to Z' => Proc.new do |posts| 
            posts.sort_by { |post| post.title.downcase }
          end, 
          'Z to A' => Proc.new do |posts| 
            posts.sort_by { |post| post.title.downcase }.reverse
          end
        },

        'Date Posted' => {
          'Most Recent First' => Proc.new do |posts| 
            posts.sort_by { |post| post.created_at }.reverse
          end,
          'Oldest First' => Proc.new do |posts| 
            posts.sort_by { |post| post.created_at }
          end 
        },

        'Length' => {
          'Longest First' => Proc.new do |posts| 
            posts.sort_by { |post| post.content.length }.reverse
          end,
          'Shortest First' => Proc.new do |posts| 
            posts.sort_by { |post| post.content.length }
          end 
        },

        'Number of Tags' => {
          'Most Tags First' => Proc.new do |posts| 
            posts.sort_by { |post| post.tags.count }.reverse
          end, 
          'Least Tags First' => Proc.new do |posts| 
            posts.sort_by { |post| post.tags.count }
          end 
        }
      }
    end 

    def set_sorting_method_names
      @sorting_method_names = {}
      methods = sorting_methods
      methods.keys.each do |method|
        @sorting_method_names[method] = methods[method].keys 
      end 
    end   

    def sort_posts_by_method(method)
      if method == nil 
        session[:sorting_method] = 'A to Z'
        method = session[:sorting_method]
      end 

      sorting_methods.each_value do |method_hash|
        if method_hash.has_key?(method)
          @posts = method_hash[method].call(@posts)
        end 
      end 
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def sort_param
      params.require(:sorting_method).permit(:method)
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :title, :summary, :post_tags).merge(author_id: current_author.id)
    end
end

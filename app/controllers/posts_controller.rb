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
    @initial_tags = Tag.all.map {|tag| tag.name }
    @current_tags = []
  end

  # GET /posts/1/edit
  def edit
    if @post.author == current_author 
      @initial_tags = Tag.all.map {|tag| tag.name }
      @current_tags = @post.tags.map {|tag| tag.name }
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
    # All methods used for sorting the posts when they are shown
    def sorting_methods
      return {
        'Title' => {
          'A to Z' => Proc.new { |posts| posts.sort_by { |post| post.title.downcase } }, 
          'Z to A' => Proc.new { |posts| posts.sort_by { |post| post.title.downcase }.reverse }
        },

        'Date Posted' => {
          'Most Recent First' => Proc.new { |posts| posts.sort_by { |post| post.created_at }.reverse },
          'Oldest First' => Proc.new { |posts| posts.sort_by { |post| post.created_at } }
        },

        'Length' => {
          'Longest First' => Proc.new { |posts| posts.sort_by { |post| post.content.length }.reverse },
          'Shortest First' => Proc.new { |posts| posts.sort_by { |post| post.content.length } }
        },

        'Number of Tags' => {
          'Most Tags First' => Proc.new { |posts| posts.sort_by { |post| post.tags.count }.reverse }, 
          'Least Tags First' => Proc.new { |posts| posts.sort_by { |post| post.tags.count } } 
        }
      }
    end 

    # The names of the <option> groups allowed for sorting posts
    def set_sorting_method_names
      @sorting_method_names = {}
      sorting_method_groups = sorting_methods
      sorting_method_groups.keys.each { |method_group| @sorting_method_names[method_group] = sorting_method_groups[method_group].keys }
    end   

    # Sorts the posts using the appropriate method
    def sort_posts_by_method(method)
      # Default to sorting lexigraphically
      if method == nil 
        session[:sorting_method] = 'A to Z'
        method = session[:sorting_method]
      end 
      # Sort posts using the appropriate procedure
      sorting_methods.each_value do |method_hash|
        @posts = method_hash.has_key?(method) ? method_hash[method].call(@posts) : @posts
      end 
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # White list the parameters used for sorting
    def sort_param
      params.require(:sorting_method).permit(:method)
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :title, :summary, :post_tags).merge(author_id: current_author.id)
    end
end
class Admin::BlogsController < AdminController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all.page(params[:page]).per(5)
  end

  def new
    @blog = Blog.new
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to admin_blogs_path, notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to admin_blogs_path, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to admin_blogs_path, notice: 'Post was successfully destroyed.' }
      format.js {}
    end
  end

  private
  def set_blog
    @blog = Blog.friendly.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :body, :preview, :slug)
  end
end

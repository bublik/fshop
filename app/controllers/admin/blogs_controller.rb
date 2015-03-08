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
    @blog.save ?
      redirect_to(admin_blogs_path, notice: 'Post was successfully created.') :
      render(:new)
  end

  def update
    @blog.update(blog_params) ?
      redirect_to(admin_blogs_path, notice: 'Post was successfully updated.') :
      render(:edit)
  end

  def destroy
    @blog.destroy ?
      redirect_to(admin_blogs_path, notice: 'Post was successfully destroyed.') :
      redirect_to(:back)
  end

  private
  def set_blog
    @blog = Blog.friendly.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :body, :preview, :slug)
  end
end
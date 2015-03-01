class BlogsController < ApplicationController
  before_action :set_blog, only: [:show]

  def index
    @blogs = Blog.all.page(params[:page]).per(5)
  end

  def show
    @blog = @blog.decorate
  end

  private
  def set_blog
    @blog = Blog.friendly.find(params[:id])
  end

end

class PostsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]
  before_action :favorite_and_comment,  :only => [:new, :create]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

 def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  private

  def favorite_and_comment
    @group = Group.find(params[:group_id])
    if  !current_user.is_member_of?(@group)
      redirect_to group_path(@group), alert: "You have no favorate,please favorate first."
    end
  end


  def post_params
    params.require(:post).permit(:content)
  end

end

module Api
  class CommentsController < ApplicationController
    def index
      @comments = Comment.all
      render json: @comments
    end

    def create
      comment = Comment.new(create_params)
      if comment.save
        @comments = Comment.all
        render json: @comments
      else
        @errors = comment.errors
        render json: @errors
      end
    end

    private

    def create_params
      params.require(:comment).permit(:author, :text)
    end
  end
end

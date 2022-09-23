class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = User.find(params[:user_id]).items.find(params[:id])
    render json: item
  end

  def create
    byebug
    item = User.find(params[:user_id]).items.create!(item_params)
    render json: item, status: :created
  end

  private

  def not_found(e)
    render status: :not_found
  end

  def invalid(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def item_params
    params.permit(:description, :name, :price)
  end
end

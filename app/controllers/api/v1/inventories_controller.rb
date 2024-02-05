module Api
  module V1
    class InventoriesController < ApplicationController
      def add_item
        @item = Item.find_by(name: item_params[:name])

        if ::Item::VALID_NAMES.include?(item_params[:name])
          @item = Item.create!(name: item_params[:name], cost: ::Item::ITEM_COSTS[item_params['name']]) if @item.nil?
        else
          render json: { error: 'Invalid item name' }, status: :bad_request and return
        end

        @user = User.find(params[:id])

        @user.inventory.items << @item
        render json: @user
      end

      private
      def item_params
        params.require(:item).permit(:name)
      end
    end
  end
end

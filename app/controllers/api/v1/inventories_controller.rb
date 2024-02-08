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

      def remove_item
        @item = Item.find_by(name: item_params[:name])
        @user = User.find(params[:id])

        if @item.nil?
          if ::Item::VALID_NAMES.include?(item_params[:name])
            render json: { error: "Item is not on user's inventory" }, status: :bad_request and return
          else
            render json: { error: 'Invalid item name' }, status: :not_found and return
          end
        end

        @user.inventory.items.delete(@item)
        render json: @user
      end

      def exchange_item
        @user = User.find(params[:id])
        @friend = User.find(params[:destination_user][:id])
        @item = @user.inventory.items.find_by(name: item_params[:name])
        if @item.nil?
          if ::Item::VALID_NAMES.include?(item_params[:name])
            render json: { error: "Item is not on user's inventory" }, status: :not_found and return
          else
            render json: { error: 'Invalid item name' }, status: :bad_request and return
          end
        end

        @friend_item = @friend.inventory.items.find_by(name: params[:destination_user][:item_name])
        if @friend_item.nil?
          if ::Item::VALID_NAMES.include?(params[:destination_user][:item_name])
            render json: { error: "Item is not on firend's inventory" }, status: :not_found and return
          else
            render json: { error: 'Invalid item name' }, status: :bad_request and return
          end
        end

        @user.inventory.items.delete(@item)
        @user.inventory.items << @friend_item

        @friend.inventory.items.delete(@friend_item)
        @friend.inventory.items << @item

        render json: @user
      end

      private
      def item_params
        params.require(:item).permit(:name)
      end
    end
  end
end

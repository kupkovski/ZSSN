# frozen_string_literal: true

module Api
  module V1
    # Controller for the actions related to manage the user's inventory
    class InventoriesController < ApplicationController
      def add_item
        @item = Item.find_by(name: item_params[:name])

        unless ::Item::VALID_NAMES.include?(item_params[:name])
          render json: { error: 'Invalid item name' }, status: :bad_request and return
        end

        @item = Item.create!(name: item_params[:name], cost: ::Item::ITEM_COSTS[item_params['name']]) if @item.nil?
        @user = User.find(params[:id])

        @user.inventory.items << @item
        render json: @user
      end

      def remove_item
        @item = Item.find_by(name: item_params[:name])
        @user = User.find(params[:id])

        if @item.nil?
          unless ::Item::VALID_NAMES.include?(item_params[:name])
            render json: { error: 'Invalid item name' }, status: :not_found and return
          end

          render json: { error: "Item is not on user's inventory" }, status: :bad_request and return
        end

        @user.inventory.items.delete(@item)
        render json: @user
      end

      def exchange_item
        @user = User.find(params[:id])
        @destination_user = User.find(destination_item_params[:id])

        if origin_item_params[:item_names].any? { |item_name| !::Item::VALID_NAMES.include?(item_name) }
          render json: { error: 'Invalid item name' }, status: :bad_request and return
        end

        @origin_items = @user.inventory.items.where(name: origin_item_params[:item_names])
        missing_items = origin_item_params[:item_names] - @origin_items.map(&:name)
        if missing_items.any?
          render json: { error: "the following items are not on origin user's inventory: #{missing_items.join(', ')}" },
                 status: :not_found and return
        end

        if destination_item_params[:item_names].any? { |item_name| !::Item::VALID_NAMES.include?(item_name) }
          render json: { error: 'Invalid item name' }, status: :bad_request and return
        end

        @destination_user_items = @destination_user.inventory.items.where(name: destination_item_params[:item_names])
        missing_items = destination_item_params[:item_names] - @destination_user_items.map(&:name)
        if missing_items.any?
          render json: {
            error: "the following items are not on destination user's inventory: #{missing_items.join(', ')}"
          }, status: :not_found and return
        end

        original_costs = @origin_items.sum(&:cost)
        destination_costs = @destination_user_items.sum(&:cost)

        if original_costs != destination_costs
          render json: { error: "the cost of exchanging items don't match" }, status: :unprocessable_entity and return
        end

        @user.inventory.items.delete(@origin_items)
        @user.inventory.items << @destination_user_items

        @destination_user.inventory.items.delete(@destination_user_items)
        @destination_user.inventory.items << @origin_items

        render json: @user
      end

      private

      def item_params
        params.require(:item).permit(:name)
      end

      def origin_item_params
        params.require(:origin_user).permit(:id, item_names: [])
      end

      def destination_item_params
        params.require(:destination_user).permit(:id, item_names: [])
      end
    end
  end
end

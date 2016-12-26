module Api
  module V1
    class UsersController < Api::V1::BaseController
      def index
        users = User.all
        render json: users
      end

      def show
        user = User.where(id: params[:id])
        render json: user
      end
    end
  end
end
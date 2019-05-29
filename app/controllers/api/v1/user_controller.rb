module Api
  module V1
    class UserController < ApplicationController
      protect_from_forgery :except => [:bulk_create_histories]
      def bulk_create_histories
        req_json = JSON.parse(request.body.read)
        idm = req_json['idm']
        histories_hash = req_json['histories']
        @user = Idm.find_by_idm(idm).user
        @created = @user.bulk_create_histories(histories_hash)
        @user.zaim_link
        render json: { status: 'SUCCESS', user: @user.name, created_count: @created.count}
      end
    end
  end
end

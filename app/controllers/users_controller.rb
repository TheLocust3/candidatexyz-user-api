require 'httparty'

class UsersController < ApplicationController
    include Request

    before_action :authenticate_user!, only: [ :index, :show, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :update, :create_invite ]

    def index
        @users = User.all
        render
    end

    def show
        @user = User.find(params[:id])
        render
    end

    def create_invite
        token = PerishableToken.create_good_until_tomorrow(current_user.id)
        subject = 'Join Staff'
        body = "<a href='#{params[:redirect_to]}?token=#{token}'>Join.</a>"

        data = post("#{Rails.application.secrets.mailer_api}/company", { to: params[:email], subject: subject, body: body })
        
        if data['status'] != 200
            render_error(data['error'])
        else
            render_success
        end
    end

    def create
        token = PerishableToken.decode(params[:token])

        if DateTime.now < token.good_until && User.find(token.data).admin
            token.destroy
            @user = User.new(create_params(params))

            if user.save
                render 'show'
            else
                render_errors(@user)
            end
        else
            render_unauthorized
        end
    end

    def update
        @user = User.find(params[:id])

        if @user.update(update_params(params))
            render 'show'
        else
            render_errors(@user)
        end
    end

    def destroy
        user = User.find(params[:id])
        user.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end

    def update_params(params)
        params.permit(:email, :first_name, :last_name, :admin)
    end
end

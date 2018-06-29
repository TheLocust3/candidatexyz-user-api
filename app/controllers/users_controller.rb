class UsersController < ApplicationController
    include CandidateXYZ::Concerns::Request
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate_user!, only: [ :index, :show, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :update, :destroy, :create_invite ]
    before_action :authenticate_campaign_id, except: [ :create ]

    def index
        @users = User.where( :campaign_id => @campaign_id, :superuser => false )

        render
    end

    def show
        @user = User.where( :id => params[:id], :campaign_id => @campaign_id).first

        if @user.nil?
            not_found
        else
            render
        end
    end

    def create_invite
        token = PerishableToken.create_good_until_tomorrow(current_user.id)
        subject = 'Join Staff'
        body = "<a href='#{params[:url]}#{token.encode}'>Join.</a>"

        data = post("#{Rails.application.secrets.mailer_api}/company", { email: params[:email], subject: subject, body: body })
        
        if data['status'].to_i >= 400
            render_error(data['error'])
        else
            render_success
        end
    end

    def create
        token = PerishableToken.decode(params[:token])
        admin_user = User.find(token.data)

        if DateTime.now < token.good_until && admin_user.admin
            params[:campaign_id] = admin_user.campaign_id
            @user = User.new(create_params(params))

            if @user.save
                token.destroy
                
                render 'show'
            else
                render_errors(@user)
            end
        else
            render_unauthorized
        end
    end

    def update
        @user = User.where( :id => params[:id], :campaign_id => @campaign_id).first

        if @user.update(update_params(params))
            render 'show'
        else
            render_errors(@user)
        end
    end

    def destroy
        user = User.where( :id => params[:id], :campaign_id => @campaign_id).first
        user.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :first_name, :last_name, :password, :password_confirmation, :campaign_id)
    end

    def update_params(params)
        params.permit(:email, :first_name, :last_name, :admin)
    end
end

class UsersController < ApplicationController
    include CandidateXYZ::Concerns::Request
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate_user!, only: [ :index, :show, :update, :destroy, :get_positions, :get_users_with_committee_positions, :update_campaign_id ]
    before_action :authenticate_admin!, only: [ :update, :destroy, :create_invite ]
    before_action :authenticate_campaign_id, except: [ :create, :get_invite ]

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

    def get_users_with_committee_positions
        @users = User.where( :campaign_id => @campaign_id ).where.not( :position => '' )

        render 'users/index'
    end

    def get_positions
        @positions = User.POSITIONS

        render 'positions'
    end

    def get_invite
        token = PerishableToken.decode(params[:token])
        @user = User.find(token.data['id'])

        render 'show'
    end

    def create_invite
        tmp_password = SecureRandom.uuid # this feels dirty
        user = User.new( :email => params[:email], position: params[:position], campaign_id: @campaign_id, created: false, :password => tmp_password, :password_confirmation => tmp_password )
        unless user.save
            render_errors(user)
            return
        end

        token = PerishableToken.create_good_until_tomorrow({ id: user.id })
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
        @user = User.find(token.data['id'])

        if DateTime.now < token.good_until
            parameters = create_params(params) # really creating a new one so use create_params
            parameters[:created] = true

            if @user.update(parameters)
                token.destroy
                post("#{Rails.application.secrets.volunteer_api}/notifications", { title: "A user has joined", body: "#{@user.first_name} #{@user.last_name} has accepted their invite", link: "/campaign/staff/#{@user.id}", campaign_id: @user.campaign_id, user_id: '' })
                
                render 'show'
            else
                render_errors(@user)
            end
        else
            render :json => {}, :status => 401
        end
    end

    def update_campaign_id
        @user = User.where( :id => params[:id]).first
        unless @user.campaign_id.nil?
            render :json => {}, :status => 401

            return
        end

        @user.campaign_id = params[:campaign_id]

        if @user.save
            render 'show'
        else
            render_errors(@user)
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
        params.permit(:email, :first_name, :middle_name, :last_name, :password, :password_confirmation, :address, :city, :state, :country, :zipcode, :phone_number, :party, :campaign_id)
    end

    def update_params(params)
        params.permit(:email, :first_name, :middle_name, :last_name, :admin, :position, :address, :city, :state, :country, :zipcode, :phone_number, :party)
    end
end

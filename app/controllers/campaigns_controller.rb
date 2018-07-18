class CampaignsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate_user!, only: [ :index, :show, :create, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :create, :update, :destroy ]
    before_action :authenticate_superuser, only: [ :index ]

    def index
        @campaigns = Campaign.all

        render
    end

    def show_by_name
        @campaign = Campaign.where( :name => params[:name] ).first

        if @campaign.nil?
            not_found
        else
            render 'show'
        end
    end

    def show
        if current_user.campaign_id == params[:id]
            @campaign = Campaign.where( :id => params[:id] ).first

            if @campaign.nil?
                not_found
            else
                render
            end
        else
            render :json => {}, :status => 401
        end
    end

    def get_users_with_committee_positions
        if current_user.campaign_id == params[:id]
            @users = User.where( :campaign_id => current_user.campaign_id ).where.not( :position => '' )

            render 'users/index'
        else
            render :json => {}, :status => 401
        end
    end

    def create
        @campaign = Campaign.new(create_params(params))

        if @campaign.save
            render 'show'
        else
            render_errors(@campaign)
        end
    end

    def update
        if current_user.campaign_id != params[:id]
            render :json => {}, :status => 401
        end

        @campaign = Campaign.find(params[:id])

        if @campaign.update(update_params(params))
            render 'show'
        else
            render_errors(@campaign)
        end
    end

    def destroy
        if current_user.campaign_id != params[:id]
            render :json => {}, :status => 401
        end

        campaign = Campaign.find(params[:id])
        campaign.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:name, :url, :election_day, :preliminary_day, :bank)
    end

    def update_params(params)
        params.permit(:name, :url, :election_day, :preliminary_day)
    end
end

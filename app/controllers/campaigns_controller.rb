class CampaignsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate_user!, only: [ :index, :show, :create, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :create, :update, :destroy ]
    before_action :authenticate_superuser, only: [ :index ]

    def index
        @campaigns = Campaign.all

        render
    end

    def show
        if current_user.campaign_id == params[:id]
            @campaign = Campaign.where( :id params[:id] ).first
            render
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
        params.permit(:name)
    end

    def update_params(params)
        params.permit(:name)
    end
end

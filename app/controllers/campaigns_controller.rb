class CampaignsController < ApplicationController
    before_action :authenticate_user!, only: [ :index, :show, :create, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :create, :update, :destroy ]

    def index
        @campaigns = Campaign.all

        render
    end

    def show
        @campaign = Campaign.find(params[:id])

        render
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
        @campaign = Campaign.find(params[:id])

        if @campaign.update(update_params(params))
            render 'show'
        else
            render_errors(@campaign)
        end
    end

    def destroy
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

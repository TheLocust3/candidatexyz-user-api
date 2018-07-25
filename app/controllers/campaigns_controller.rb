class CampaignsController < ApplicationController
    include CandidateXYZ::Concerns::Request
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate_user!, only: [ :index, :show, :create, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :update, :destroy ]
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

    def create
        unless @current_user.campaign_id.nil?
            render :json => {}, :status => 401

            return
        end

        @campaign = Campaign.new(create_params(params))

        if @campaign.save
            post("#{Rails.application.secrets.volunteer_api}/notifications", { title: "Form your campaign's Political Action Committee", body: "", link: "/campaign/committee", campaign_id: @campaign.id, user_id: '' })
            post("#{Rails.application.secrets.volunteer_api}/notifications", { title: "Appoint/invite a Candidate", body: "Invite them to your campaign or appoint an existing user as candidate", link: "/campaign/invite-staff", campaign_id: @campaign.id, user_id: '' })
            post("#{Rails.application.secrets.volunteer_api}/notifications", { title: "Appoint/invite a committee Chair", body: "Invite them to your campaign or appoint an existing user as chair", link: "/campaign/invite-staff", campaign_id: @campaign.id, user_id: '' })
            post("#{Rails.application.secrets.volunteer_api}/notifications", { title: "Appoint/invite a committee Treasurer", body: "Invite them to your campaign or appoint an existing user as treasurer", link: "/campaign/invite-staff", campaign_id: @campaign.id, user_id: '' })

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

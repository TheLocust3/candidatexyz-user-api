class PasswordsController < DeviseTokenAuth::PasswordsController
    include CandidateXYZ::Concerns::Request

    def create
        super do |resource|
            token = resource.reset_password_token
      
            post("#{Rails.application.secrets.mailer_api}/reset_password", { email: resource.email, token: token })

            render :json => { 'status': 'ok' }

            return
        end
    end
end

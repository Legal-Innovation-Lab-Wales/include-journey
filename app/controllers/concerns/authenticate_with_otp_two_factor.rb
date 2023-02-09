module AuthenticateWithOtpTwoFactor
    extend ActiveSupport::Concern

    def authenticate_with_otp_two_factor
        team_member = self.resource = find_team_member
    
        if team_member_params[:otp_attempt].present? && session[:otp_team_member_id]
          authenticate_team_member_with_otp_two_factor(team_member)
        elsif team_member&.valid_password?(team_member_params[:password])
          prompt_for_otp_two_factor(team_member)
        end
    end

    private

    def valid_otp_attempt?(team_member)
        team_member.validate_and_consume_otp!(team_member_params[:otp_attempt]) ||
            team_member.invalidate_otp_backup_code!(team_member_params[:otp_attempt])
    end

    def prompt_for_otp_two_factor(team_member)
        @team_member = team_member
    
        session[:otp_team_member_id] = team_member.id
        render 'devise/sessions/two_factor'
    end

    def authenticate_team_member_with_otp_two_factor(team_member)
        if valid_otp_attempt?(team_member)
          # Remove any lingering team_member data from login
          session.delete(:otp_team_member_id)

          team_member.save!
          sign_in(team_member, event: :authentication)
        else
          flash.now[:alert] = 'Invalid two-factor code.'
          prompt_for_otp_two_factor(team_member)
        end
    end

    def team_member_params
        params.require(:team_member).permit(:email, :password, :otp_attempt)
    end

    def find_team_member
        if session[:otp_team_member_id]
          TeamMember.find(session[:otp_team_member_id])
        elsif team_member_params[:email]
          TeamMember.find_by(email: team_member_params[:email])
        end
    end    

    def otp_two_factor_enabled?
        find_team_member&.otp_required_for_login
    end

end

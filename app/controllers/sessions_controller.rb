class SessionsController < ApplicationController
  # GET /sessions/new
  def new
  end

  # POST /sessions
  # POST /sessions.json
  def create
    oauth_session = new_session
    respond_to do |format|
      if !oauth_session.has_errors?
        oauth_session.save_to(session)
        format.html { redirect_to videos_path }
        format.json { render :show, status: :created, location: oauth_session }
      else
        format.html { redirect_back alert: oauth_session.errors.join(', '), fallback_location: new_session_path }
        format.json { render json: oauth_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions
  # DELETE /sessions.json
  def destroy
    session.clear
    respond_to do |format|
      format.html { redirect_to new_session_url }
      format.json { head :no_content }
    end
  end

private

  def new_session
    OauthSession.create(**session_params)
  end

  def session_params
    params.permit(:username, :password).to_h.symbolize_keys
  end
end

class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, :if => Proc.new { |c| request.domain == ENV['operator_app_url'] }

  def index
    if request.domain == ENV['operator_app_url'] && signed_in? && !params[:o].present?
      redirect_to request.path + "?o=#{current_user.uid}"
    end
  end

  def template
    render :template => 'templates/' + params[:path], :layout => nil
  end

end

class Api::ChatsController < ApplicationController
  def create
    campaign = Campaign.where(:uid => params[:campaign_uid]).first
    visitor = User.where(:visitor_uid => params[:visitor_uid]).first
    operator = User.where(:operator_uid => params[:operator_uid]).first

    if campaign && visitor
      chat = Chat.create!(:campaign_id => campaign.id, :visitor_id => visitor.id)
      Pusher["operator_#{operator.operator_uid}"].trigger('newchat', {
        chat_uid: chat.uid,
        visitor_uid: visitor.visitor_uid,
        visitor_name: visitor.fullname,
        visitor_profile: ""
      })
      render json: { chat_uid: chat.uid, operator: operator.as_json(:as => :operator) }, status: 201
    elsif !campaign
      render json: { error: "Campaign not found" }, status: 500 
    elsif !visitor
      render json: { error: "Visitor not found" }, status: 500 
    end
  end

  def operator_params
    params.permit(:campaign_uid, :visitor_uid)
  end
end

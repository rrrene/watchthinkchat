class Chat < ActiveRecord::Base
  belongs_to :operator, :class_name => "User"
  belongs_to :visitor, :class_name => "User"
  belongs_to :campaign
  has_many :messages

  before_validation :set_uid

  validates :uid, :visitor_id, presence: true

  scope :open, lambda { where(:status => "open") }

  def set_uid
    return uid if uid

    loop do
      self.uid = SecureRandom.hex(10)
      break uid unless Chat.find_by(uid: uid)
    end
  end

  def close!
    Pusher["chat_#{self.uid}"].trigger('end', { })
    self.update_attribute(:status, "closed")
  end

  def collect_stats(params)
    name_words = params[:visitor_name].split(' ')
    people = MissionHub::Person.find(:all, :params => { :filters => { :email => params[:visitor_email] }})
    if people.length == 0
      visitor = MissionHub::Person.create(first_name: name_words.shift, last_name: name_words.join(' '), email: params[:visitor_email])
    else
      visitor = people.first
    end
    MissionHub::FollowupComment.create(contact_id: visitor.id, commenter_id: self.operator.missionhub_id, comment: params[:notes])
  end
end

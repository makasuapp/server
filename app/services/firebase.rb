# typed: strict

require 'fcm'

class Firebase
  extend T::Sig

  sig {void}
  def initialize
    @fcm = FCM.new(ENV["FCM_SERVER_KEY"])
  end

  sig { params(topic_name: String, data: T.untyped).void }
  def send_data(topic_name, data)
    #should we type the response instead of void?
    @fcm.send_to_topic(topic_name, data: data)
  end

  sig { params(topic_name: String, body: String, title: T.nilable(String)).void }
  def send_notification(topic_name, body, title = nil)
    #should we type the response instead of void?
    @fcm.send_to_topic(topic_name, notification: {title: title, body: body})
  end
end
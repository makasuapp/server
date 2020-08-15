# typed: strict

require 'fcm'

class Firebase
  extend T::Sig

  sig {void}
  def initialize
    @fcm = FCM.new(ENV["FCM_SERVER_KEY"])
  end

  sig { params(topic_name: String, json_data: T.untyped).returns(T.untyped)}
  def send_data(topic_name, json_data)
    @fcm.send_to_topic(topic_name, data: json_data)
  end

  sig { params(topic_name: String, body: String, title: T.nilable(String)).returns(T.untyped)}
  def send_notification(topic_name, body, title = nil)
    @fcm.send_to_topic(topic_name, notification: {title: title, body: body})
  end
end
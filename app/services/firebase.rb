# typed: true

require 'fcm'

class Firebase
  extend T::Sig

  sig {void}
  def initialize
    @fcm = FCM.new(ENV["FCM_SERVER_KEY"])
  end

  # this doesn't seem to work anymore for iOS?? title can't be nil it seems??
  # sig { params(topic_name: String, message_type: String, json_str: String).returns(T.untyped)}
  # def send_data(topic_name, message_type, json_str)
  #   @fcm.send_to_topic(topic_name, {
  #       notification: {title: nil, body: "", content_available: true}, 
  #       data: {type: message_type, content: json_str}
  #     })
  # end

  sig { params(topic_name: String, title: String, body: T.nilable(String)).returns(T.untyped)}
  def send_notification(topic_name, title, body = nil)
    @fcm.send_to_topic(topic_name, {
      notification: {title: title, body: body, content_available: true}
    })
  end

  sig { params(topic_name: String, title: String, message_type: String, 
    json_str: String, body: T.nilable(String)).returns(T.untyped)}
  def send_notification_with_data(topic_name, title, message_type, json_str, body = nil)
    @fcm.send_to_topic(topic_name, {
        notification: {title: title, body: body, content_available: true}, 
        data: {type: message_type, content: json_str}
      })
  end
end
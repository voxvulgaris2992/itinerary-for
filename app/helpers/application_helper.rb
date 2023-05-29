module ApplicationHelper
  def lowercase_first_letter(message)
    message.first.downcase + message[1..-1]
  end
end

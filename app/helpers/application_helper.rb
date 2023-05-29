module ApplicationHelper
  def lowercase_first_letter(message)
    message.first.downcase + message[1..-1]
  end
  def budget_to_s(budget)
    case budget
    when 1
      '$'
    when 2
      '$$'
    when 3
      '$$$'
    when 4
      '$$$$'
    end
  end
end

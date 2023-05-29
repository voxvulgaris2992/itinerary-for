class Itinerary < ApplicationRecord
  has_many :events
  has_many :places
  validates :address, :budget, presence: true
  validates :date, presence: true
  validates :start_time, :end_time, presence: true
  validate :at_least_one_interest, :date_check, :start_time_check, :end_time_check

  private

  def at_least_one_interest
    if interests.blank? || interests.reject(&:blank?).empty?
      errors.add(:interests, "can't be blank")
    end
  end

  def date_check
    errors.add(:date, "can't be in the past") if date.present? && date < Date.today
  end

  def start_time_check
    if start_time.present?
      if start_time < Time.now
        errors.add(:start_time, "can't be in the past")
      elsif start_time >= end_time
        errors.add(:start_time, "can't be later than end time")
      end
    end
  end

  def end_time_check
    errors.add(:end_time, "can't be in the past") if end_time.present? && end_time < Time.now
  end
end

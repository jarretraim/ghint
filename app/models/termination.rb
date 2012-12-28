class Termination < ActiveRecord::Base
  attr_accessible :fullname, :location, :manager, :processed_by, :term_date, :username, :uuid

  def to_s
    "User '#{username}' termed at #{term_date}. ID: #{uuid}"
  end
end

class GithubUser < ActiveRecord::Base
  attr_accessible :login
  belongs_to :user
end

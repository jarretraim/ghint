class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :trackable

  has_one :github_user

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username

  validates_presence_of :username
end

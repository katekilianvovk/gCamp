class User < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :comments, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_secure_password

  def full_name
    "#{self.first_name}" + " #{self.last_name}"
  end

  def is_owner?(project)
    self.memberships.find_by(project_id: project.id) && self.memberships.find_by(project_id: project.id).role_id == 1 || self.is_admin?
  end

  def is_member?(membership)
    self.id == membership.user_id || self.is_admin?
  end

  def is_admin?
    self.admin == true
  end

  def co_member?(user)
    user.projects.map { |project| project.users }.flatten.include?(self)
  end

  def tracker_token
    unless self.token == nil
      "#{token[0..3]}***********************"
    end
  end



end

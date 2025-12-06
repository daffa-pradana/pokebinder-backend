class RefreshToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token_and_set_expires

  scope :active, -> {
    where(revoked: false).where("expires_at > ?", Time.current)
  }

  def revoke!
    update!(revoked: true)
  end

  private

  def generate_token_and_set_expires
    self.token ||= SecureRandom.urlsafe_base64(64)
    self.expires_at ||= 30.days.from_now
  end
end

class Micropost < ApplicationRecord
  MICROPOSTS_PARAMS_PERMIT = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_max_lenght}
  validates :image, content_type: {in: Settings.micropost.content_type_image},
    size: {less_than: Settings.micropost.image_size.megabytes}

  scope :recent_posts, ->{order created_at: :desc}
  scope :micropost_feed, ->(user_id){where user_id: user_id if user_id.present?}

  def display_image
    image.variant resize_to_limit: [Settings.number.size, Settings.number.size]
  end
end

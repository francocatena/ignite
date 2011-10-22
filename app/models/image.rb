class Image < ActiveRecord::Base
  has_attached_file :image, styles: ->(attachment) {attachment.instance.styles}
  
  # Restricciones
  validates :name, :caption, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: true
  validates_attachment_presence :image,
    message: -> { ::I18n.t('errors.messages.blank') }
  validates_attachment_content_type :image, content_type: /^image\//i
  
  def styles
    { large: '600x600>', medium: '300x300>', thumb: '100x100>' }
  end
end
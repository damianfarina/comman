module Coverable
  extend ActiveSupport::Concern

  included do
    has_one_attached :cover do |attachable|
      attachable.variant :hero, resize_to_fill: [ 400, 400 ]
      attachable.variant :thumb, resize_to_fill: [ 100, 100 ]
    end
  end

  def cover_thumbnail
    if cover.attached?
      cover.variant(:thumb)
    else
      default_cover
    end
  end

  def cover_hero
    if cover.attached?
      cover.variant(:hero)
    else
      default_cover
    end
  end

  def cover_filename
    if cover.attached?
      cover.blob.filename
    end
  end

  private

  def default_cover
    filename = "default-#{self.class.name.downcase}.png"
    filepath = Rails.root.join("app", "assets", "images", filename)

    if File.exist?(filepath)
      ActionController::Base.helpers.image_path("default-#{self.class.name.downcase}.png")
    else
      ActionController::Base.helpers.image_path("default-cover.png")
    end
  end
end

require 'liquid'
require 'flickr.rb'

API_KEY = 'fef6644edfac9a21a909f8152719aaa3'
SIZES = {:square => "Square", :large_square => "Large Square", :thumbnail => "Thumbnail", :small =>
"Small", :small320 => "Small 320", :medium => "Medium", :medium640 => "Medium 640", :medium800 => "Medium 640", 
:large => "Large", :large1600 => "Large", :large2048 => "Large", :original => "Large", :panoramic => "Large"}

module FlickrM
  @printed = false

  def flickr_img(image_id, size = :medium, attrs = {})
    img = image_object(image_id, get_size_segment(size.downcase.to_sym))
    attrs[:style] = "height: 175px;" if (size == "panoramic")
    image_tag(img[:title], img[:url], attrs)
  end

  private

  def get_size_segment(symbol)
    SIZES[symbol]
  end

  def image_object(image_id, size)
      begin
        img = Flickr::Photo.new(image_id, API_KEY)
        return {:title => img.title, :url => img.source(size)}
      rescue => e
        p e.backtrace
        p "IMAGE NOT FOUND: id: #{image_id} - size: #{size}: #{e}"
        {:title => "not found", :url => "#"}
      end
  end

  def image_tag(title, url, attrs)
    "<img alt='#{title}' src='#{url}' #{image_attrs(attrs)}>"
  end

  def image_attrs(attrs)
    string_of_attributes = ""
    attrs.each {|k, v| string_of_attributes += "#{k}=\"#{v}\""}
    string_of_attributes
  end
end

Liquid::Template.register_filter(FlickrM)